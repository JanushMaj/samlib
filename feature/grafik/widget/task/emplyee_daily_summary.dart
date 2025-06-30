import 'dart:math';
import 'package:flutter/material.dart';

import '../../../../domain/models/emplyee.dart';
import '../../../../domain/models/grafik/impl/task_element.dart';
import '../../../../domain/models/grafik/impl/time_issue_element.dart';
import '../../../../theme/app_tokens.dart';

class EmployeeDailySummary extends StatelessWidget {
  final List<TaskElement> tasks;
  final List<Employee> employees;
  final List<TimeIssueElement> timeIssues;

  const EmployeeDailySummary({
    super.key,
    required this.tasks,
    required this.employees,
    required this.timeIssues,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, List<TaskElement>> employeeTasks = {};
    for (final task in tasks) {
      for (final workerId in task.workerIds) {
        employeeTasks.putIfAbsent(workerId, () => []).add(task);
      }
    }

    final Map<String, List<TimeIssueElement>> employeeIssues = {};
    for (final issue in timeIssues) {
      employeeIssues.putIfAbsent(issue.workerId, () => []).add(issue);
    }

    final List<String> partials = [];
    final List<String> conflicts = [];

    for (final employee in employees) {
      final uid = employee.uid;
      final surname = employee.fullName.split(' ').first;
      final userTasks = employeeTasks[uid] ?? [];
      final userIssues = employeeIssues[uid] ?? [];

      userTasks.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
      final List<String> ranges = [];
      DateTime? lastEnd;
      bool hasConflict = false;

      for (final task in userTasks) {
        final start = task.startDateTime;
        final end = task.endDateTime;
        if (lastEnd != null && lastEnd.isAfter(start)) {
          hasConflict = true;
        }
        lastEnd = end;

        if (start.hour < 15 && end.hour > 7) {
          final from = max(7, start.hour);
          final to = min(15, end.hour);
          ranges.add("$from-$to");
        }
      }

      for (final issue in userIssues) {
        final start = issue.startDateTime;
        final end = issue.endDateTime;

        // Całodniowa nieobecność – różne daty
        if (start.day != end.day || start.month != end.month || start.year != end.year) {
          ranges.add("7-15");
          continue;
        }

        if (start.isAtSameMomentAs(end)) {
          continue;
        }

        if (start.hour < 15 && end.hour > 7) {
          final from = max(7, start.hour);
          final to = min(15, end.hour);
          if (from < to) {
            ranges.add("$from-$to");
          }
        }
      }

      if (hasConflict) {
        final orderIds = userTasks.map((e) => e.orderId).toSet().join(", ");
        conflicts.add("$surname: $orderIds");
      }

      final coveredHours = _flattenRanges(ranges);
      if (coveredHours.length < 8) {
        final freeRanges = _inverseRanges(coveredHours);
        final display = freeRanges.map((r) => "${r[0]}-${r[1]}").join(", ");
        partials.add("$surname: $display");
      }
    }

    if (partials.isEmpty && conflicts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (partials.isNotEmpty) ...[
          Text(
            "Pozostali pracownicy (wolne przedziały):",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: Text(
                  (partials..sort()).join('  •  '),
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (conflicts.isNotEmpty) ...[
          Text(
            "Konflikty czasowe:",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: Text(
                  (conflicts..sort()).join('  •  '),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.red),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  List<int> _flattenRanges(List<String> ranges) {
    final covered = <int>{};
    for (final range in ranges) {
      final parts = range.split('-');
      final from = int.parse(parts[0]);
      final to = int.parse(parts[1]);
      for (int i = from; i < to; i++) {
        covered.add(i);
      }
    }
    return covered.toList()..sort();
  }

  List<List<int>> _inverseRanges(List<int> covered) {
    final List<List<int>> free = [];
    int current = 7;
    while (current < 15) {
      if (!covered.contains(current)) {
        int start = current;
        while (current < 15 && !covered.contains(current)) {
          current++;
        }
        free.add([start, current]);
      } else {
        current++;
      }
    }
    return free;
  }
}
