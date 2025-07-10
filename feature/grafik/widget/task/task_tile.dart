import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/feature/grafik/cubit/grafik_cubit.dart';
import 'package:kabast/domain/models/grafik/enums.dart';
import 'package:kabast/domain/models/grafik/task_assignment.dart';
import 'package:kabast/domain/models/grafik/impl/display_task_assignment.dart'
    as display;
import '../../constants/enums_ui.dart';
import '../dialog/grafik_element_popup.dart';
import 'transfer_list.dart';
import 'task_header.dart';
import 'employee_chip_list.dart';
import 'assignment_list.dart';
import 'vehicle_list.dart';

class TaskTile extends StatelessWidget {
  final TaskElement task;
  const TaskTile({Key? key, required this.task}) : super(key: key);

  // Mapy ikon i kolorów
  static const _typeIcons = {
    GrafikTaskType.Produkcja: Icons.apartment,
    GrafikTaskType.Budowa:     Icons.home_repair_service,
    GrafikTaskType.Serwis:     Icons.handyman,
    GrafikTaskType.Inne:       Icons.task_alt,
  };
  static const _borderColors = {
    GrafikTaskType.Produkcja: Colors.blue,
    GrafikTaskType.Budowa:     Colors.orange,
    GrafikTaskType.Serwis:     Colors.green,
    GrafikTaskType.Inne:       Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    // Pobierz dane
    final state      = context.watch<GrafikCubit>().state;
    final assignedIds = state.assignments
        .where((a) => a.taskId == task.id)
        .map((a) => a.workerId)
        .toSet();
    final employees =
        state.employees.where((e) => assignedIds.contains(e.uid));
    final vehicles   = state.vehicles .where((v) => task.carIds.contains(v.id));
    final transfers  = state.taskTransferDisplayMapping[task.id];

    final typeIcon    = _typeIcons[task.taskType] ?? Icons.task;
    final borderColor = _borderColors[task.taskType] ?? Colors.grey;
    final statusIcon  = task.status.icon;

    return GestureDetector(
      onTap: () => showGrafikElementPopup(context, task),
      child: Container(
        margin: const EdgeInsets.only(
          left: AppSpacing.xs,
          right: AppSpacing.xs,
          bottom: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: AppSpacing.borderThin),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TaskHeader(task: task, typeIcon: typeIcon, statusIcon: statusIcon),
            if (assignedIds.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: AssignmentList(
                  assignments: state.assignments
                      .where((a) => a.taskId == task.id)
                      .map((a) => display.DisplayTaskAssignment(
                            workerId: a.workerId,
                            startDateTime: a.startDateTime,
                            endDateTime: a.endDateTime,
                          ))
                      .toList(),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Text(
                  'Brak przypisanych pracowników',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            EmployeeChipList(employees: employees),
            if (vehicles.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: VehicleList(vehicleIds: task.carIds),
              ),
            // Komunikaty transferowe
            if (transfers != null && transfers.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                child: TransferList(transferInfo: transfers),
              ),
          ],
        ),
      ),
    );
  }
}
