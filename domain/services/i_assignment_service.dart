import '../models/grafik/assignment.dart';

abstract class IAssignmentService {
  Stream<List<Assignment>> getAssignmentsWithinRange({
    required DateTime start,
    required DateTime end,
  });
}
