import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/feature/grafik/form/time_issue_row.dart';
import 'package:kabast/feature/permission/permission_widget.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:kabast/domain/models/grafik/enums.dart';
import 'package:kabast/feature/grafik/cubit/grafik_cubit.dart';
import 'package:kabast/feature/grafik/cubit/grafik_state.dart';
import 'package:kabast/feature/grafik/form/standard_task_row.dart';
import 'employee_daily_summary.dart';
import 'task_tile.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';

class TaskList extends StatelessWidget {
  final DateTime date;

  const TaskList({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GrafikCubit, GrafikState>(
      builder: (context, state) {
        final tasks = state.tasks;
        final employees = state.employees;
        final issues = state.issues;

        if (tasks.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm * 3),
              child: Text(
                AppStrings.noTasksToday,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          );
        }

        final standardTasks =
        tasks.where((task) => task.orderId == "0001").toList();
        final nonStandardTasks =
        tasks.where((task) => task.orderId != "0001").toList();

        return LayoutBuilder(
          builder: (context, constraints) {
            final List<Widget> children = [
              Column(
                children: [
                  PermissionWidget(
                    permission: "canEditGrafik",
                    child: EmployeeDailySummary(
                      tasks: tasks,
                      employees: employees,
                      timeIssues: issues,
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
              final isWide = constraints.maxWidth > 600;
              final columns = isWide
                  ? _splitTasksEvenly(nonStandardTasks)
                  : {
                'left': _sortTasksForSingleColumn(nonStandardTasks),
                'right': <TaskElement>[]
              };

              children.add(
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: columns['left']!
                              .map((task) => Flexible(child: TaskTile(task: task)))
                              .toList(),
                        ),
                      ),
                      if (isWide) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            children: columns['right']!
                                .map((task) => Flexible(child: TaskTile(task: task)))
                                .toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }

            return Column(children: children);
          },
        );
      },
    );
  }

  List<TaskElement> _sortTasksForSingleColumn(List<TaskElement> tasks) {
    // Ustaw priorytet: Produkcja > Inne > Serwis > Budowa
    final order = {
      GrafikTaskType.Produkcja: 0,
      GrafikTaskType.Inne:       1,
      GrafikTaskType.Serwis:     2,
      GrafikTaskType.Budowa:     3,
    };

    tasks.sort((a, b) {
      final aOrder = order[a.taskType] ?? 999;
      final bOrder = order[b.taskType] ?? 999;
      return aOrder.compareTo(bOrder);
    });

    return tasks;
  }

  /// Rozdziela zadania na dwie kolumny, z priorytetem: Produkcja > Inne > Serwis > Budowa
  /// Lewa kolumna może mieć jeden element więcej niż prawa.
  Map<String, List<TaskElement>> _splitTasksEvenly(
      List<TaskElement> tasks,
      ) {
    final order = {
      GrafikTaskType.Produkcja: 0,
      GrafikTaskType.Inne:       1,
      GrafikTaskType.Serwis:     2,
      GrafikTaskType.Budowa:     3,
    };
    final sorted = [...tasks]
      ..sort((a, b) =>
          (order[a.taskType] ?? 999).compareTo(order[b.taskType] ?? 999));

    final mid = (sorted.length + 1) ~/ 2;
    final left = sorted.sublist(0, mid);
    final right = sorted.sublist(mid);

    return {'left': left, 'right': right};
  }
}
