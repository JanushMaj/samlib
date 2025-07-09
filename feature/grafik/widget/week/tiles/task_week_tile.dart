import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/feature/grafik/cubit/grafik_cubit.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile.dart';
import 'package:kabast/shared/turbo_grid/turbo_grid.dart';

import '../../../../../shared/turbo_grid/widgets/clock_view_delegate.dart';
import '../../../../../shared/turbo_grid/widgets/simple_text_delegate.dart';
import '../../../../../theme/app_tokens.dart';
import '../../dialog/grafik_element_popup.dart';
import 'package:kabast/domain/models/grafik/impl/task_assignment.dart';

class TaskWeekTile extends StatelessWidget {
  final TaskElement task;
  const TaskWeekTile({Key? key, required this.task}) : super(key: key);

  String _formatEmployeeName(String fullName) {
    final parts = fullName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0]} ${parts[1][0]}.';
    }
    return fullName;
  }

  String _buildEmployeeNames(BuildContext context) {
    final state = context.read<GrafikCubit>().state;
    if (task.assignments.isNotEmpty) {
      final byWorker = <String, List<TaskAssignment>>{};
      for (final a in task.assignments) {
        byWorker.putIfAbsent(a.workerId, () => []).add(a);
      }
      return byWorker.entries.map((e) {
        final emp = state.employees.firstWhere(
          (em) => em.uid == e.key,
          orElse: () => null,
        );
        final name = emp != null
            ? _formatEmployeeName(emp.fullName)
            : e.key;
        final times = e.value
            .map((a) => '${a.startDateTime.hour.toString().padLeft(2,'0')}-${a.endDateTime.hour.toString().padLeft(2,'0')}')
            .join(', ');
        return '$name $times';
      }).join(", ");
    } else {
      final filteredEmployees = state.employees
          .where((employee) => task.workerIds.contains(employee.uid))
          .toList();
      return filteredEmployees
          .map((employee) => _formatEmployeeName(employee.fullName))
          .join(", ");
    }
  }

  String _buildCarDescriptions(BuildContext context, List<String> carIds) {
    final state = context.read<GrafikCubit>().state;
    final filteredVehicles = state.vehicles
        .where((vehicle) => carIds.contains(vehicle.id))
        .toList();

    return filteredVehicles
        .map((v) => '${v.brand} ${v.color}')
        .join(", ");
  }

  Color _backgroundColor(BuildContext context) {
    return Colors.lightBlue.shade100;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showGrafikElementPopup(context, task),
      child: Container(
        decoration: BoxDecoration(
          color: _backgroundColor(context),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return TurboGrid(
              tiles: [
                // 1. Kafelek – przedział czasu
                TurboTile(
                  priority: 1,
                  required: true,
                  delegate: ClockViewDelegate(
                    start: task.startDateTime,
                    end: task.endDateTime,
                  ),
                ),
                // 2. additionalInfo
                TurboTile(
                  priority: 1,
                  required: true,
                  delegate: SimpleTextDelegate(text: task.additionalInfo),
                ),
                // 3. pracownicy
                TurboTile(
                  priority: 1,
                  required: true,
                  delegate: SimpleTextDelegate(
                    text: _buildEmployeeNames(context),
                  ),
                ),
                // 4. orderId
                TurboTile(
                  priority: 3,
                  required: false,
                  delegate: SimpleTextDelegate(text: task.orderId),
                ),
                // 5. status
                TurboTile(
                  priority: 4,
                  required: false,
                  delegate: SimpleTextDelegate(text: task.status.name),
                ),
                // 6. taskType
                TurboTile(
                  priority: 5,
                  required: false,
                  delegate: SimpleTextDelegate(text: task.taskType.name),
                ),
                // 7. carIds
                TurboTile(
                  priority: 2,
                  required: true,
                  delegate: SimpleTextDelegate(text: _buildCarDescriptions(context, task.carIds)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
