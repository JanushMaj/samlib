import 'dart:async';

import '../../domain/models/grafik/assignment.dart';
import '../../domain/models/grafik/task_assignment.dart';
import 'task_assignment_repository.dart';

class AssignmentRepository {
  final TaskAssignmentRepository _taskAssignmentRepo;

  AssignmentRepository(this._taskAssignmentRepo);

  /// Stream zwracający przypisania pracowników z zakresu dat.
  Stream<List<Assignment>> getAssignmentsWithinRange({
    required DateTime start,
    required DateTime end,
  }) {
    return _taskAssignmentRepo
        .getAssignmentsWithinRange(start: start, end: end)
        .map(
          (list) => list
              .map(
                (a) => Assignment(
                  id:
                      '${a.taskId}_${a.workerId}_${a.startDateTime.millisecondsSinceEpoch}',
                  taskId: a.taskId,
                  workerId: a.workerId,
                  startDateTime: a.startDateTime,
                  endDateTime: a.endDateTime,
                ),
              )
              .toList(),
        );
  }

  /// Oblicza łączny czas pracy danego pracownika na podstawie przypisań z
  /// kolekcji `task_assignments`.
  Future<Duration> getTotalWorkTime({
    required String workerId,
    required DateTime start,
    required DateTime end,
  }) async {
    final assignments = await _taskAssignmentRepo
        .getAssignmentsWithinRange(start: start, end: end)
        .first;

    Duration total = Duration.zero;
    for (final a in assignments) {
      if (a.workerId != workerId) continue;
      final s = a.startDateTime.isBefore(start) ? start : a.startDateTime;
      final f = a.endDateTime.isAfter(end) ? end : a.endDateTime;
      final diff = f.difference(s);
      if (diff.isNegative) continue;
      total += diff;
    }
    return total;
  }
}
