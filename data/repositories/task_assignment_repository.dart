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
}
