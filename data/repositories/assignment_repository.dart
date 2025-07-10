import 'dart:async';

import '../../domain/models/grafik/assignment.dart';
import '../../domain/models/grafik/impl/task_element.dart';
import '../../domain/services/i_assignment_service.dart';
import 'grafik_element_repository.dart';

class AssignmentRepository {
  final IAssignmentService _assignmentService;
  final GrafikElementRepository _grafikRepo;

  AssignmentRepository(
    this._assignmentService, // zarejestrowane w GetIt
  ) : _grafikRepo = GrafikElementRepository(_assignmentService); // lub osobny konstruktor, jeśli chcesz

  /// Stream zwracający przypisania pracowników z zakresu dat.
  Stream<List<Assignment>> getAssignments({
    required DateTime start,
    required DateTime end,
  }) {
    return _assignmentService.getAssignmentsWithinRange(start: start, end: end);
  }

  /// Oblicza łączny czas pracy danego pracownika na podstawie zadań (TaskElement).
  Future<Duration> getTotalWorkTime({
    required String workerId,
    required DateTime start,
    required DateTime end,
  }) async {
    final elements = await _grafikRepo
        .getElementsWithinRange(start: start, end: end, types: ['TaskElement'])
        .first;

    Duration total = Duration.zero;
    for (final e in elements.whereType<TaskElement>()) {
      final matches = e.assignments.where((a) => a.workerId == workerId);
      for (final a in matches) {
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
