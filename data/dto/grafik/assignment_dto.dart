import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/grafik/assignment.dart';

class AssignmentDto {
  final String id;
  final String taskId;
  final String workerId;
  final DateTime startDateTime;
  final DateTime endDateTime;

  AssignmentDto({
    required this.id,
    required this.taskId,
    required this.workerId,
    required this.startDateTime,
    required this.endDateTime,
  });

  factory AssignmentDto.fromJson(Map<String, dynamic> json) {
    return AssignmentDto(
      id: json['id'] as String? ?? '',
      taskId: json['taskId'] as String? ?? '',
      workerId: json['workerId'] as String? ?? '',
      startDateTime: _parseDateTime(json['startDateTime']),
      endDateTime: _parseDateTime(json['endDateTime']),
    );
  }

  factory AssignmentDto.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>? ?? {})..putIfAbsent('id', () => doc.id);
    return AssignmentDto.fromJson(data);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'taskId': taskId,
        'workerId': workerId,
        'startDateTime': Timestamp.fromDate(startDateTime),
        'endDateTime': Timestamp.fromDate(endDateTime),
      };

  Assignment toDomain() => Assignment(
        id: id,
        taskId: taskId,
        workerId: workerId,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
      );

  static AssignmentDto fromDomain(Assignment a) => AssignmentDto(
        id: a.id,
        taskId: a.taskId,
        workerId: a.workerId,
        startDateTime: a.startDateTime,
        endDateTime: a.endDateTime,
      );

  static DateTime _parseDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    if (value is DateTime) return value;
    return DateTime.now();
  }
}
