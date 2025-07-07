import 'dart:math';
import 'package:rxdart/rxdart.dart';

import '../repositories/grafik_element_repository.dart';
import '../repositories/employee_repository.dart';
import '../../domain/models/grafik/grafik_element.dart';
import '../../domain/models/grafik/impl/task_element.dart';
import '../../domain/models/grafik/impl/time_issue_element.dart';
import '../../domain/models/employee.dart';

class MappingResult {
  final Map<String, List<String>> taskTimeIssueMapping;
  final Map<String, List<String>> transferMapping;

  MappingResult({
    required this.taskTimeIssueMapping,
    required this.transferMapping,
  });
}

class TaskIssueMappingService {
  final GrafikElementRepository _grafikRepo;
  final EmployeeRepository _employeeRepo;

  TaskIssueMappingService(this._grafikRepo, this._employeeRepo);

  Stream<MappingResult> mappingForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = DateTime(day.year, day.month, day.day, 23, 59, 59, 999);

    final grafikStream = _grafikRepo.getElementsWithinRange(
      start: start,
      end: end,
      types: ['TaskElement', 'TimeIssueElement'],
    );
    final employeeStream = _employeeRepo.getEmployees();

    return Rx.combineLatest2<List<GrafikElement>, List<Employee>, MappingResult>(
      grafikStream,
      employeeStream,
      (elements, employees) {
        final tasks = elements.whereType<TaskElement>().toList();
        final issues = elements.whereType<TimeIssueElement>().toList();

        final mapping = _calculateTaskTimeIssueMapping(
          tasks: tasks,
          issues: issues,
          employees: employees,
        );

        final transferMapping = _calculateTaskTransferMapping(
          tasks: tasks,
          employees: employees,
        );

        return MappingResult(
          taskTimeIssueMapping: mapping,
          transferMapping: transferMapping,
        );
      },
    );
  }

  Map<String, List<String>> _calculateTaskTimeIssueMapping({
    required List<TaskElement> tasks,
    required List<TimeIssueElement> issues,
    required List<Employee> employees,
  }) {
    final mapping = <String, List<String>>{};

    for (var task in tasks) {
      final displayStrings = <String>[];

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
        if (!task.workerIds.contains(workerId)) continue;

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

  Map<String, List<String>> _calculateTaskTransferMapping({
    required List<TaskElement> tasks,
    required List<Employee> employees,
  }) {
    final mapping = <String, List<String>>{};

    for (var employee in employees) {
      final workerTasks =
          tasks.where((task) => task.workerIds.contains(employee.uid)).toList();
      if (workerTasks.isEmpty) continue;
      workerTasks.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));

      for (int i = 0; i < workerTasks.length - 1; i++) {
        final earlierTask = workerTasks[i];
        final laterTask = workerTasks[i + 1];

        if (earlierTask.endDateTime.isAfter(laterTask.startDateTime)) {
          final surname = employee.fullName.split(' ').first;
          final message = "Przeniesienie $surname na ${laterTask.orderId}";
          if (mapping.containsKey(earlierTask.id)) {
            mapping[earlierTask.id]!.add(message);
          } else {
            mapping[earlierTask.id] = [message];
          }
        }
      }
    }
    return mapping;
  }
}

