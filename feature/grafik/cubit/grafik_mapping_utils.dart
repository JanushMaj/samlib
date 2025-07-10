import 'dart:math';
import 'package:kabast/domain/models/employee.dart';
import 'package:kabast/domain/models/grafik/assignment.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/domain/models/grafik/impl/time_issue_element.dart';

Map<String, List<String>> calculateTaskTimeIssueDisplayMapping({
  required List<TaskElement> tasks,
  required List<TimeIssueElement> issues,
  required List<Employee> employees,
}) {
  final mapping = <String, List<String>>{};

  for (var task in tasks) {
    final displayStrings = <String>[];

    // Zostawiamy tylko kwestie czasowe które potencjalnie mają coś wspólnego z taskiem
    for (var issue in issues) {
      final overlapStart = max(
        task.startDateTime.millisecondsSinceEpoch,
        issue.startDateTime.millisecondsSinceEpoch,
      );
      final overlapEnd = min(
        task.endDateTime.millisecondsSinceEpoch,
        issue.endDateTime.millisecondsSinceEpoch,
      );
      final overlapDuration = Duration(milliseconds: overlapEnd - overlapStart);
      if (overlapDuration.inMinutes <= 0) continue;

      final workerId = issue.workerId;
      if (!task.assignments.any((a) => a.workerId == workerId)) continue;

      try {
        final employee = employees.firstWhere((e) => e.uid == workerId);
        final surname = employee.fullName.split(' ').first;
        final typeDisplay = issue.issueType.name;
        final start = issue.startDateTime;
        final end = issue.endDateTime;
        final timeRange =
            "${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}-"
            "${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}";
        final displayText = "$surname $typeDisplay $timeRange";
        displayStrings.add(displayText);
      } catch (_) {
        continue;
      }
    }

    mapping[task.id] = displayStrings;
  }

  return mapping;
}


/// Generuje komunikaty transferów na podstawie przypisań pracowników.
/// Każdy transfer opisuje moment przejścia pracownika z jednego zadania do kolejnego.
Map<String, List<String>> calculateTaskTransferDisplayMapping({
  required List<TaskElement> tasks,
  required List<Employee> employees,
  required List<Assignment> assignments,
}) {
  final mapping = <String, List<String>>{};
  final tasksById = {for (final t in tasks) t.id: t};

  final assignmentsByWorker = <String, List<Assignment>>{};
  for (final a in assignments) {
    assignmentsByWorker.putIfAbsent(a.workerId, () => []).add(a);
  }

  assignmentsByWorker.forEach((workerId, workerAssignments) {
    workerAssignments.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));

    for (var i = 0; i < workerAssignments.length - 1; i++) {
      final current = workerAssignments[i];
      final next = workerAssignments[i + 1];
      if (current.taskId == next.taskId) continue;

      try {
        final employee = employees.firstWhere((e) => e.uid == workerId);
        final toTask = tasksById[next.taskId];
        if (toTask == null) continue;
        final time = next.startDateTime;
        final timeStr =
            "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
        final message =
            "Przeniesienie ${employee.surname} na ${toTask.orderId} o $timeStr";
        mapping.putIfAbsent(current.taskId, () => []).add(message);
      } catch (_) {
        continue;
      }
    }
  });

  return mapping;}