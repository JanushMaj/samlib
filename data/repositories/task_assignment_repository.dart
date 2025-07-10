import '../../domain/models/grafik/task_assignment.dart';
import '../../domain/services/i_task_assignment_service.dart';

class TaskAssignmentRepository {
  final ITaskAssignmentService _service;

  TaskAssignmentRepository(this._service);

  Stream<List<TaskAssignment>> getAssignmentsForTask(String taskId) {
    return _service.getAssignmentsForTask(taskId);
  }

  Future<void> saveTaskAssignment(TaskAssignment assignment) {
    return _service.addTaskAssignment(assignment);
  }

  Stream<List<TaskAssignment>> getAssignmentsWithinRange({
    required DateTime start,
    required DateTime end,
  }) {
    return _service.getAssignmentsWithinRange(start: start, end: end);
  }
}
