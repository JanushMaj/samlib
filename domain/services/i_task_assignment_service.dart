import '../models/grafik/task_assignment.dart';

abstract class ITaskAssignmentService {
  Stream<List<TaskAssignment>> getAssignmentsForTask(String taskId);
  Future<void> addTaskAssignment(TaskAssignment assignment);
  Future<void> deleteAssignmentsForTask(String taskId);
  Stream<List<TaskAssignment>> getAssignmentsWithinRange({
    required DateTime start,
    required DateTime end,
  });
}
