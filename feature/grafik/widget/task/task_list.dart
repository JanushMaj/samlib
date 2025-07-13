import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/feature/grafik/form/time_issue_row.dart';
import 'package:kabast/feature/permission/permission_widget.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:kabast/theme/theme.dart';
import 'package:kabast/shared/responsive/responsive_layout.dart';
import '../../../auth/auth_cubit.dart';
import '../../cubit/grafik_cubit.dart';
import '../../cubit/grafik_state.dart';
import '../../form/standard_task_row.dart';
import 'employee_daily_summary.dart';
import 'package:kabast/shared/grafik_element_card.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/domain/models/grafik/grafik_element_data.dart';
import 'package:kabast/shared/utils/tile_size_resolver.dart';

class TaskList extends StatelessWidget {
  final DateTime date;
  final Breakpoint breakpoint;
  final bool showAll;

  const TaskList({
    Key? key,
    required this.date,
    required this.breakpoint,
    required this.showAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GrafikCubit, GrafikState>(
      builder: (context, state) {
        // Create a mutable copy so we can apply filtering and sorting
        List<TaskElement> tasks = List.from(state.tasks);
        if (!showAll) {
          final currentUser = context.read<AuthCubit>().currentUser;
          final userId = currentUser?.employeeId;
          final assignedIds = state.assignments
              .where((a) => a.workerId == userId)
              .map((a) => a.taskId)
              .toSet();
          tasks = tasks.where((t) => assignedIds.contains(t.id)).toList();
        }
        // Sort tasks by custom rules
        int typeIndex(GrafikTaskType t) {
          switch (t) {
            case GrafikTaskType.Produkcja:
              return 0;
            case GrafikTaskType.Inne:
              return 1;
            case GrafikTaskType.Budowa:
              return 2;
            case GrafikTaskType.Serwis:
              return 3;
          }
        }

        tasks.sort((a, b) {
          final type = typeIndex(a.taskType).compareTo(typeIndex(b.taskType));
          if (type != 0) return type;

          final start = a.startDateTime.compareTo(b.startDateTime);
          if (start != 0) return start;

          final durationA = a.endDateTime.difference(a.startDateTime).inMinutes;
          final durationB = b.endDateTime.difference(b.startDateTime).inMinutes;
          return durationA.compareTo(durationB);
        });

        final employees = state.employees;
        final issues = state.issues;

        if (tasks.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm * 3),
              child: Text(
                AppStrings.noTasksToday,
                textAlign: TextAlign.center,
                style: AppTheme.textStyleFor(
                  breakpoint,
                  Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
          );
        }

        final standardTasks =
            tasks.where((task) => task.orderId == "0001").toList();
        final nonStandardTasks =
            tasks.where((task) => task.orderId != "0001").toList();

        final List<Widget> children = [
          Column(
            children: [
              PermissionWidget(
                permission: "canEditGrafik",
                child: EmployeeDailySummary(
                  tasks: tasks,
                  employees: employees,
                  timeIssues: issues,
                  assignments: context.read<GrafikCubit>().state.assignments,
                ),
              ),
              TimeIssueRow(timeIssues: issues),
            ],
          ),
          const SizedBox(height: AppSpacing.sm * 2),
        ];

        if (standardTasks.isNotEmpty) {
          children.add(
            StandardTaskRow(standardTasks: standardTasks),
          );
        }

        if (nonStandardTasks.isNotEmpty) {
          final columns = switch (breakpoint) {
            Breakpoint.small => 1,
            Breakpoint.medium => 2,
            Breakpoint.large => 2,
          };

          children.add(
            Expanded(
              child: LayoutBuilder(
                builder: (context, gridConstraints) {
                  final taskCount = nonStandardTasks.length;
                  final rows = (taskCount / columns).ceil();

                  final totalSpacingHeight =
                      AppSpacing.sm * (rows > 0 ? rows - 1 : 0);
                  final availableHeight =
                      gridConstraints.maxHeight - totalSpacingHeight;
                  final tileHeight =
                      rows > 0 ? availableHeight / rows : gridConstraints.maxHeight;

                  final tileWidth =
                      (gridConstraints.maxWidth - AppSpacing.sm * (columns - 1)) /
                          columns;
                  final aspectRatio = tileWidth / tileHeight;

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: AppSpacing.sm,
                      mainAxisSpacing: AppSpacing.sm,
                      childAspectRatio: aspectRatio,
                    ),
                    itemCount: nonStandardTasks.length,
                    itemBuilder: (context, index) {
                      final task = nonStandardTasks[index];
                      final assignments = state.assignments
                          .where((a) => a.taskId == task.id)
                          .toList();
                      final employees = state.employees
                          .where((e) => assignments.any((a) => a.workerId == e.uid))
                          .toList();
                      final vehicles = state.vehicles
                          .where((v) => task.carIds.contains(v.id))
                          .toList();
                      final data = GrafikElementData(
                        assignedEmployees: employees,
                        assignedVehicles: vehicles,
                        assignments: assignments,
                      );
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final variant = TileSizeResolver.resolve(
                              width: constraints.maxWidth);
                          return GrafikElementCard(
                            element: task,
                            data: data,
                            variant: variant,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          );
        }

        return Column(children: children);
      },
    );
  }

  // Deprecated layout helpers removed
}
