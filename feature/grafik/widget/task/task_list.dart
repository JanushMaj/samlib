import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/feature/grafik/form/time_issue_row.dart';
import 'package:kabast/feature/permission/permission_widget.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:kabast/theme/theme.dart';
import 'package:kabast/shared/responsive/responsive_layout.dart';
import '../../../auth/auth_cubit.dart';
import '../../../../domain/models/grafik/enums.dart';
import '../../cubit/grafik_cubit.dart';
import '../../cubit/grafik_state.dart';
import '../../form/standard_task_row.dart';
import 'employee_daily_summary.dart';
import '../../../shared/task_card.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';

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
        List<TaskElement> tasks = state.tasks;
        if (!showAll) {
          final currentUser = context.read<AuthCubit>().currentUser;
          final userId = currentUser?.employeeId;
          final assignedIds = state.assignments
              .where((a) => a.workerId == userId)
              .map((a) => a.taskId)
              .toSet();
          tasks = tasks.where((t) => assignedIds.contains(t.id)).toList();
        }
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
            Breakpoint.large => 3,
          };

          children.add(
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: AppSpacing.sm,
                  mainAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 3,
                ),
                itemCount: nonStandardTasks.length,
                itemBuilder: (context, index) => TaskCard(
                  task: nonStandardTasks[index],
                ),
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
