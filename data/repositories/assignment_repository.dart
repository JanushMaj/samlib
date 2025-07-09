import 'dart:async';

import '../../domain/models/grafik/impl/task_element.dart';
import 'grafik_element_repository.dart';

class AssignmentRepository {
  final GrafikElementRepository _grafikRepo;

  AssignmentRepository(this._grafikRepo);

  /// Returns the total work time of [workerId] within the given period.
  /// The result is the sum of task durations (in minutes) where
  /// the employee is assigned.
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
      if (!e.workerIds.contains(workerId)) continue;
      final s = e.startDateTime.isBefore(start) ? start : e.startDateTime;
      final f = e.endDateTime.isAfter(end) ? end : e.endDateTime;
      final diff = f.difference(s);
      if (diff.isNegative) continue;
      total += diff;
    }
    return total;
  }
}
