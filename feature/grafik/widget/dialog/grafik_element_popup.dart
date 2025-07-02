import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:kabast/data/repositories/grafik_element_repository.dart';
import 'package:kabast/data/repositories/app_user_repository.dart';
import 'package:kabast/domain/models/grafik/grafik_element.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/domain/models/grafik/impl/delivery_planning_element.dart';
import 'package:kabast/domain/models/grafik/impl/task_planning_element.dart';
import 'package:kabast/domain/models/grafik/impl/time_issue_element.dart';
import 'package:kabast/domain/models/grafik/impl/task_planning_to_task_extension.dart';
import 'package:kabast/domain/models/grafik/enums.dart';
import 'package:kabast/feature/permission/permission_widget.dart';
import 'package:kabast/injection.dart';

import '../../cubit/grafik_cubit.dart';
import '../task/employee_list.dart';
import '../task/vehicle_list.dart';

Future<void> showGrafikElementPopup(
    BuildContext parentContext,
    GrafikElement element,
    ) {
  final grafikCubit = Provider.of<GrafikCubit>(parentContext, listen: false);

  return showDialog(
    context: parentContext,
    useRootNavigator: false,
    builder: (BuildContext context) {
      return Provider<GrafikCubit>.value(
        value: grafikCubit,
        child: GrafikElementPopup(element: element),
      );
    },
  );
}

class GrafikElementPopup extends StatefulWidget {
  final GrafikElement element;

  const GrafikElementPopup({super.key, required this.element});

  @override
  State<GrafikElementPopup> createState() => _GrafikElementPopupState();
}

class _GrafikElementPopupState extends State<GrafikElementPopup> {
  GrafikStatus? _status;
  GrafikElement get _element => widget.element;

  final _repo = getIt<GrafikElementRepository>();
  final _userRepo = getIt<AppUserRepository>();
  String? _userFullName;

  @override
  void initState() {
    super.initState();
    if (_element is TaskElement) {
      _status = (_element as TaskElement).status;
    }
    _loadUserFullName();
  }

  Future<void> _loadUserFullName() async {
    final uid = _element.addedByUserId;
    if (uid == null || uid.isEmpty) return;

    final userStream = _userRepo.getUserStream(uid);
    userStream.first.then((user) {
      if (user != null && mounted) {
        setState(() => _userFullName = user.fullName);
      }
    });
  }

  Future<void> _saveStatus() async {
    if (_status == null) return;
    await _repo.updateTaskStatus(_element.id, _status!);
    if (mounted) Navigator.of(context).pop();
  }

  List<Widget> _buildMeta() => [
    const Divider(height: 24),
    Text('Zamknięte: ${_element.closed ? 'Tak' : 'Nie'}'),
    if (_userFullName != null && _userFullName!.isNotEmpty)
      Text('Dodane przez: $_userFullName'),
    if (_element.addedTimestamp != null)
      Text('Dodano: ${DateFormat('dd.MM.yyyy HH:mm').format(_element.addedTimestamp!)}'),
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Szczegóły elementu'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${_element.id}'),
            Text('Start: ${DateFormat('dd.MM.yyyy HH:mm').format(_element.startDateTime)}'),
            Text('Koniec: ${DateFormat('dd.MM.yyyy HH:mm').format(_element.endDateTime)}'),
            Text('Info: ${_element.additionalInfo}'),
            ..._buildMeta(),
            const SizedBox(height: 8),
            if (_element is TaskElement)
              ..._buildTaskElementDetails(_element as TaskElement),
            if (_element is DeliveryPlanningElement)
              ..._buildDeliveryPlanningDetails(_element as DeliveryPlanningElement),
            if (_element is TaskPlanningElement)
              ..._buildTaskPlanningDetails(_element as TaskPlanningElement),
            if (_element is TimeIssueElement)
              ..._buildTimeIssueDetails(_element as TimeIssueElement),
            if (_element is TaskElement) ...[
              const SizedBox(height: 16),
              const Text('Zmień status:'),
              DropdownButtonFormField<GrafikStatus>(
                value: _status,
                isExpanded: true,
                items: GrafikStatus.values
                    .map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(s.name.split('.').last),
                ))
                    .toList(),
                onChanged: (val) => setState(() => _status = val),
              ),
            ],
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_element is TaskPlanningElement)
              PermissionWidget(
                permission: 'canEditGrafik',
                child: TextButton(
                  onPressed: () {
                    final task = (_element as TaskPlanningElement).toTaskElement();
                    Navigator.of(context).pushNamed('/addGrafik', arguments: task);
                  },
                  child: const Text('Utwórz zadanie'),
                ),
              ),
            if (_element is TaskElement)
              PermissionWidget(
                permission: 'canEditGrafik',
                child: TextButton(
                  onPressed: _saveStatus,
                  child: const Text('Zapisz status'),
                ),
              ),
            PermissionWidget(
              permission: 'canEditGrafik',
              child: TextButton(
                onPressed: () {
                  getIt<GrafikElementRepository>().deleteGrafikElement(_element.id);
                  Navigator.of(context).pop();
                },
                child: const Text('Usuń'),
              ),
            ),
            PermissionWidget(
              permission: 'canEditGrafik',
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/addGrafik', arguments: _element);
                },
                child: const Text('Edytuj'),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Zamknij'),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildTaskElementDetails(TaskElement task) => [
    const Text('Pracownicy:'),
    EmployeeList(employeeIds: task.workerIds),
    const SizedBox(height: 8),
    Text('Order ID: ${task.orderId}'),
    Text('Status: ${task.status.name}'),
    Text('Task Type: ${task.taskType.name}'),
    const SizedBox(height: 8),
    const Text('Pojazdy:'),
    VehicleList(vehicleIds: task.carIds),
  ];

  List<Widget> _buildDeliveryPlanningDetails(DeliveryPlanningElement delivery) =>
      [
        Text('Order ID: ${delivery.orderId}'),
        Text('Category: ${delivery.category.name}'),
      ];

  List<Widget> _buildTaskPlanningDetails(TaskPlanningElement planning) => [
    Text('Worker Count: ${planning.workerCount}'),
    Text('Order ID: ${planning.orderId}'),
    Text('Probability: ${planning.probability.name}'),
    Text('Task Type: ${planning.taskType.name}'),
    Text('Minutes: ${planning.minutes}'),
    Text('Pilne: ${planning.highPriority ? 'Tak' : 'Nie'}'),
  ];

  List<Widget> _buildTimeIssueDetails(TimeIssueElement issue) => [
    Text('Reason: ${issue.issueType}'),
    Text('Payment Type: ${issue.issuePaymentType}'),
    Text('Worker ID: ${issue.workerId}'),
  ];
}
