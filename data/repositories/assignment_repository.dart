import '../../domain/models/grafik/assignment.dart';
import '../../domain/services/i_assignment_service.dart';

class AssignmentRepository {
  final IAssignmentService _service;
  AssignmentRepository(this._service);

  Stream<List<Assignment>> getAssignments({
    required DateTime start,
    required DateTime end,
  }) {
    return _service.getAssignmentsWithinRange(start: start, end: end);
  }
}
