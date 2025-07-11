import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/feature/grafik/constants/enums_ui.dart';
import 'package:kabast/feature/grafik/cubit/grafik_cubit.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:kabast/theme/theme.dart';
import 'package:kabast/shared/responsive/responsive_layout.dart';
import '../feature/grafik/widget/task/employee_chip_list.dart';
import '../feature/grafik/widget/task/vehicle_list.dart';

class TaskCard extends StatelessWidget {
  final TaskElement task;
  final bool showEmployees;
  final bool showVehicles;

  const TaskCard({
    Key? key,
    required this.task,
    this.showEmployees = true,
    this.showVehicles = true,
  }) : super(key: key);

  static const _typeIcons = {
    GrafikTaskType.Produkcja: Icons.apartment,
    GrafikTaskType.Budowa: Icons.home_repair_service,
    GrafikTaskType.Serwis: Icons.handyman,
    GrafikTaskType.Inne: Icons.task_alt,
  };

  String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GrafikCubit>().state;
    final assignedIds = state.assignments
        .where((a) => a.taskId == task.id)
        .map((a) => a.workerId)
        .toSet();
    final employees = state.employees.where((e) => assignedIds.contains(e.uid));
    final vehicles = state.vehicles.where((v) => task.carIds.contains(v.id));

    final typeIcon = _typeIcons[task.taskType] ?? Icons.task;
    final statusIcon = task.status.icon;

    return Card(
      margin: const EdgeInsets.all(AppSpacing.xs),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(typeIcon,
                    size: AppTheme.sizeFor(context.breakpoint, 24)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    task.additionalInfo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.textStyleFor(
                      context.breakpoint,
                      Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(statusIcon,
                    size: AppTheme.sizeFor(context.breakpoint, 24)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${_fmt(task.startDateTime)} - ${_fmt(task.endDateTime)}',
              style: AppTheme.textStyleFor(
                context.breakpoint,
                Theme.of(context).textTheme.bodyMedium!,
              ),
            ),
            if (showEmployees && employees.isNotEmpty) ...[
              const SizedBox(height: 4),
              EmployeeChipList(employees: employees),
            ],
            if (showVehicles && vehicles.isNotEmpty) ...[
              const SizedBox(height: 4),
              VehicleList(vehicleIds: task.carIds),
            ],
          ],
        ),
      ),
    );
  }
}
