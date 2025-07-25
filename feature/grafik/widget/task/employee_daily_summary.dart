import 'dart:math';
import 'package:flutter/material.dart';

import '../../../../domain/models/employee.dart';
import '../../../../domain/models/grafik/impl/task_element.dart';
import '../../../../domain/models/grafik/impl/time_issue_element.dart';
import '../../../../theme/app_tokens.dart';
import '../../../../domain/models/grafik/task_assignment.dart';
import '../../../../domain/models/grafik/enums.dart';

class EmployeeDailySummary extends StatelessWidget {
  final List<TaskElement> tasks;
  final List<Employee> employees;
  final List<TimeIssueElement> timeIssues;
  final List<TaskAssignment> assignments;

  const EmployeeDailySummary({
    super.key,
    required this.tasks,
    required this.employees,
    required this.timeIssues,
    required this.assignments,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, dynamic>>> employeeEntries = {};
    for (final a in assignments) {
      final task = tasks.firstWhere(
        (t) => t.id == a.taskId,
        orElse: () => TaskElement(
          id: a.taskId,
          startDateTime: a.startDateTime,
          endDateTime: a.endDateTime,
          additionalInfo: '',
          orderId: '',
          status: GrafikStatus.Realizacja,
          taskType: GrafikTaskType.Inne,
          carIds: const [],
          addedByUserId: '',
          addedTimestamp: DateTime.now(),
          closed: false,
        ),
      );
      employeeEntries.putIfAbsent(a.workerId, () => []).add({
        'start': task.startDateTime,
        'end': task.endDateTime,
        'orderId': task.orderId,
      });
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
      final userEntries = employeeEntries[uid] ?? [];
      final userIssues = employeeIssues[uid] ?? [];
      userEntries.sort((a, b) =>
          (a['start'] as DateTime).compareTo(b['start'] as DateTime));
      final List<String> ranges = [];
      DateTime? lastEnd;
      bool hasConflict = false;

      for (final entry in userEntries) {
        final start = entry['start'] as DateTime;
        final end = entry['end'] as DateTime;
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
        final orderIds = userEntries
            .map((e) => e['orderId'] as String)
            .toSet()
            .join(", ");
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
