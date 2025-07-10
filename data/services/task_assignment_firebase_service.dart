import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/grafik/task_assignment.dart';
import '../../domain/services/i_task_assignment_service.dart';
import '../dto/grafik/task_assignment_dto.dart';

class TaskAssignmentFirebaseService implements ITaskAssignmentService {
  final FirebaseFirestore _firestore;

  TaskAssignmentFirebaseService(this._firestore);

  @override
  Stream<List<TaskAssignment>> getAssignmentsForTask(String taskId) {
    return _firestore
        .collection('task_assignments')
        .where('taskId', isEqualTo: taskId)
        .snapshots()
        .map((query) => query.docs
            .map((doc) => TaskAssignmentDto.fromFirestore(doc).toDomain())
            .toList());
  }

  @override
  Future<void> addTaskAssignment(TaskAssignment assignment) async {
    final dto = TaskAssignmentDto.fromDomain(assignment);
    await _firestore.collection('task_assignments').add(dto.toJson());
  }

  @override
  Future<void> deleteAssignmentsForTask(String taskId) async {
    final query = await _firestore
        .collection('task_assignments')
        .where('taskId', isEqualTo: taskId)
        .get();
    for (final doc in query.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Stream<List<TaskAssignment>> getAssignmentsWithinRange({
    required DateTime start,
    required DateTime end,
  }) {
    return _firestore
        .collection('task_assignments')
        .where('startDateTime', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .where('endDateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .snapshots()
        .map((query) => query.docs
            .map((doc) => TaskAssignmentDto.fromFirestore(doc).toDomain())
            .toList());
  }
}
