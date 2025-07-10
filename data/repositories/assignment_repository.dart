import 'dart:async';

import '../../domain/models/grafik/assignment.dart';
import '../../domain/models/grafik/impl/task_element.dart';
import '../../domain/models/grafik/task_assignment.dart';
import '../../domain/services/i_assignment_service.dart';
import 'grafik_element_repository.dart';
import 'task_assignment_repository.dart';

class AssignmentRepository {
  final IAssignmentService _assignmentService;
  final GrafikElementRepository _grafikRepo;
  final TaskAssignmentRepository _taskAssignmentRepo;

  AssignmentRepository(
    this._assignmentService,
    this._grafikRepo,
    this._taskAssignmentRepo,
  );

  /// Stream zwracający przypisania pracowników z zakresu dat.
  Stream<List<Assignment>> getAssignments({
    required DateTime start,
    required DateTime end,
  }) {
    return _assignmentService.getAssignmentsWithinRange(start: start, end: end);
  }

  /// Oblicza łączny czas pracy danego pracownika na podstawie przypisań z
  /// kolekcji `task_assignments`.
  Future<Duration> getTotalWorkTime({
    required String workerId,
    required DateTime start,
    required DateTime end,
  }) async {
    final elements = await _grafikRepo
        .getElementsWithinRange(start: start, end: end, types: ['TaskElement'])
        .first;

    Duration total = Duration.zero;
    for (final task in elements.whereType<TaskElement>()) {
      final assignments = await _taskAssignmentRepo
          .getAssignmentsForTask(task.id)
          .first;
      for (final a in assignments) {
        if (a.workerId != workerId) continue;
        final s = a.startDateTime.isBefore(start) ? start : a.startDateTime;
        final f = a.endDateTime.isAfter(end) ? end : a.endDateTime;
        final diff = f.difference(s);
        if (diff.isNegative) continue;
        total += diff;
      }
    }
    return total;
  }
}
