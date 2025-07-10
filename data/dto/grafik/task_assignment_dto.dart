import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/models/grafik/impl/task_assignment.dart';

class TaskAssignmentDto {
  final String taskId;
  final String workerId;
  final DateTime startDateTime;
  final DateTime endDateTime;

  TaskAssignmentDto({
    required this.taskId,
    required this.workerId,
    required this.startDateTime,
    required this.endDateTime,
  });

  factory TaskAssignmentDto.fromJson(Map<String, dynamic> json) {
    DateTime parse(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      return DateTime.now();
    }

    return TaskAssignmentDto(
      taskId: json['taskId'] as String? ?? '',
      workerId: json['workerId'] as String? ?? '',
      startDateTime: parse(json['startDateTime']),
      endDateTime: parse(json['endDateTime']),
    );
  }

  factory TaskAssignmentDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return TaskAssignmentDto.fromJson(data);
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'workerId': workerId,
      'startDateTime': Timestamp.fromDate(startDateTime),
      'endDateTime': Timestamp.fromDate(endDateTime),
    };
  }

  TaskAssignment toDomain() {
    return TaskAssignment(
      taskId: taskId,
      workerId: workerId,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
    );
  }

  factory TaskAssignmentDto.fromDomain(TaskAssignment assignment) {
    return TaskAssignmentDto(
      taskId: assignment.taskId,
      workerId: assignment.workerId,
      startDateTime: assignment.startDateTime,
      endDateTime: assignment.endDateTime,
    );
  }
}
