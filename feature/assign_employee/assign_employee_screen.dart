import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_tokens.dart';
import '../../shared/responsive/responsive_layout.dart';
import '../../shared/form/custom_button.dart';
import '../../data/repositories/employee_repository.dart';
import '../auth/auth_cubit.dart';
import "../../data/repositories/app_user_repository.dart";
import '../employee/employee_picker.dart';

class AssignEmployeeScreen extends StatefulWidget {
  const AssignEmployeeScreen({super.key});

  @override
  State<AssignEmployeeScreen> createState() => _AssignEmployeeScreenState();
}

class _AssignEmployeeScreenState extends State<AssignEmployeeScreen> {
  String? _selectedId;
  Set<String> _disabledIds = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDisabled());
  }

  Future<void> _loadDisabled() async {
    final employees = await GetIt.I<EmployeeRepository>().getEmployees().first;
    final repo = GetIt.I<AppUserRepository>();
    final currentUid = context.read<AuthCubit>().currentUser?.id;
    final results = await Future.wait(
      employees.map((e) => repo.getUserByEmployeeId(e.uid)),
    );
    final used = <String>{};
    for (var i = 0; i < employees.length; i++) {
      final user = results[i];
      if (user != null && user.id != currentUid) {
        used.add(employees[i].uid);
      }
    }
    if (!mounted) return;
    setState(() {
      _disabledIds = used;
      _loading = false;
      if (_selectedId != null && _disabledIds.contains(_selectedId)) {
        _selectedId = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('[AssignEmployeeScreen] build');
    final employeeStream = GetIt.I<EmployeeRepository>().getEmployees();
    return ResponsiveScaffold(
      appBar: AppBar(title: const Text(AppStrings.assignEmployeeTitle)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ResponsivePadding(
              small: const EdgeInsets.all(16),
              medium: const EdgeInsets.all(24),
              large: const EdgeInsets.all(32),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          EmployeePicker(
                            employeeStream: employeeStream,
                            singleSelection: true,
                            disabledEmployeeIds: _disabledIds,
                            initialSelectedIds:
                                _selectedId == null ? [] : [_selectedId!],
                            onSelectionChanged: (employees) {
                              setState(() {
                                _selectedId = employees.isNotEmpty
                                    ? employees.first.uid
                                    : null;
                              });
                            },
                          ),
                          const SizedBox(height: AppSpacing.sm * 6),
                          CustomButton(
                            text: AppStrings.assignMe,
                            onPressed: _selectedId == null
                                ? null
                                : () async {
                                    final user =
                                        context.read<AuthCubit>().currentUser;
                                    if (user != null) {
                                      final updated =
                                          user.copyWith(employeeId: _selectedId);
                                      await GetIt.I<AppUserRepository>()
                                          .saveUser(updated);
                                    }
                                    if (mounted) Navigator.of(context).pop();
                                  },
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
