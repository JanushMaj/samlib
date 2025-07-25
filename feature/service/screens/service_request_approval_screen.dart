import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../data/repositories/grafik_element_repository.dart';
import '../../../data/repositories/service_request_repository.dart';
import '../../../data/repositories/task_assignment_repository.dart';
import '../../../data/repositories/employee_repository.dart';
import '../../../domain/models/app_user.dart';
import '../../../domain/models/employee.dart';
import '../../../domain/models/grafik/impl/service_request_element.dart';
import '../../../domain/models/grafik/impl/service_request_to_task_extension.dart';
import '../../../domain/models/grafik/task_assignment.dart';
import '../../../domain/models/grafik/enums.dart';
import '../../auth/auth_cubit.dart';
import '../../auth/screen/no_access_screen.dart';
import '../../employee/employee_picker.dart';
import '../../../shared/app_drawer.dart';
import '../../../shared/responsive/responsive_layout.dart';
import '../../../theme/app_tokens.dart';

class ServiceRequestApprovalScreen extends StatelessWidget {
  const ServiceRequestApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().currentUser;
    if (user == null ||
        (user.role != UserRole.kierownik &&
            user.role != UserRole.kierownikProdukcji &&
            user.role != UserRole.admin)) {
      return const NoAccessScreen();
    }

    return BlocProvider(
      create: (_) => ServiceRequestApprovalCubit(
        GetIt.I<GrafikElementRepository>(),
        GetIt.I<TaskAssignmentRepository>(),
        GetIt.I<ServiceRequestRepository>(),
      ),
      child: const _ServiceRequestApprovalView(),
    );
  }
}

class _ServiceRequestApprovalView extends StatelessWidget {
  const _ServiceRequestApprovalView();

  Stream<List<ServiceRequestElement>> _requests(
      ServiceRequestRepository repo) {
    return repo
        .watchServiceRequests()
        .map((list) => list
            .where((r) => r.status == ServiceRequestStatus.pending)
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    final reqRepo = GetIt.I<ServiceRequestRepository>();
    final empRepo = GetIt.I<EmployeeRepository>();

    return BlocListener<ServiceRequestApprovalCubit, ServiceRequestApprovalState>(
      listener: (context, state) {
        if (state.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Zgłoszenie zatwierdzone')),
          );
        } else if (state.errorMsg != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Błąd: ${state.errorMsg}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: ResponsiveScaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text('Zatwierdź zgłoszenia serwisowe'),
        ),
        body: StreamBuilder<List<ServiceRequestElement>>(
          stream: _requests(reqRepo),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Błąd danych\n${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final requests = snapshot.data!;
            if (requests.isEmpty) {
              return const Center(child: Text('Brak zgłoszeń'));
            }
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final req = requests[index];
                return _RequestApprovalTile(
                  request: req,
                  employeeStream: empRepo.getEmployees(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _RequestApprovalTile extends StatefulWidget {
  final ServiceRequestElement request;
  final Stream<List<Employee>> employeeStream;
  const _RequestApprovalTile({
    required this.request,
    required this.employeeStream,
  });

  @override
  State<_RequestApprovalTile> createState() => _RequestApprovalTileState();
}

class _RequestApprovalTileState extends State<_RequestApprovalTile> {
  Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ServiceRequestApprovalCubit>();
    final req = widget.request;
    final order = req.orderNumber.isEmpty ? '(brak numeru)' : req.orderNumber;
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(req.description),
            const SizedBox(height: AppSpacing.sm),
            EmployeePicker(
              employeeStream: widget.employeeStream,
              initialSelectedIds: _selected.toList(),
              onSelectionChanged: (emps) {
                setState(() => _selected = emps.map((e) => e.uid).toSet());
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _selected.isEmpty
                    ? null
                    : () => cubit.approveRequest(req, _selected.toList()),
                child: const Text('Zatwierdź'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ServiceRequestApprovalState {
  final bool isSubmitting;
  final bool success;
  final String? errorMsg;

  ServiceRequestApprovalState({
    required this.isSubmitting,
    required this.success,
    this.errorMsg,
  });

  factory ServiceRequestApprovalState.initial() =>
      ServiceRequestApprovalState(isSubmitting: false, success: false);

  ServiceRequestApprovalState copyWith({
    bool? isSubmitting,
    bool? success,
    String? errorMsg,
  }) {
    return ServiceRequestApprovalState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      success: success ?? this.success,
      errorMsg: errorMsg,
    );
  }
}

class ServiceRequestApprovalCubit
    extends Cubit<ServiceRequestApprovalState> {
  final GrafikElementRepository _grafikRepo;
  final TaskAssignmentRepository _assignmentRepo;
  final ServiceRequestRepository _requestRepo;

  ServiceRequestApprovalCubit(
    this._grafikRepo,
    this._assignmentRepo,
    this._requestRepo,
  ) : super(ServiceRequestApprovalState.initial());

  Future<void> approveRequest(
    ServiceRequestElement request,
    List<String> workerIds,
  ) async {
    emit(state.copyWith(isSubmitting: true, success: false, errorMsg: null));
    final taskId = _grafikRepo.generateNewTaskId();
    final task = request.toTaskElement().copyWithId(taskId);
    try {
      await _grafikRepo.saveGrafikElement(task);
      for (final id in workerIds) {
        final assignment = TaskAssignment(
          taskId: taskId,
          workerId: id,
          startDateTime: task.startDateTime,
          endDateTime: task.endDateTime,
        );
        await _assignmentRepo.saveTaskAssignment(assignment);
      }
      final updated = ServiceRequestElement(
        id: request.id,
        createdBy: request.addedByUserId,
        createdAt: request.addedTimestamp,
        location: request.location,
        description: request.description,
        orderNumber: request.orderNumber,
        urgency: request.urgency,
        suggestedDate: request.suggestedDate,
        estimatedDuration: request.estimatedDuration,
        requiredPeopleCount: request.requiredPeopleCount,
        taskType: request.taskType,
        status: ServiceRequestStatus.approved,
        taskId: taskId,
      );
      await _requestRepo.saveServiceRequest(updated);
      emit(state.copyWith(isSubmitting: false, success: true));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        success: false,
        errorMsg: e.toString(),
      ));
    }
  }
}
