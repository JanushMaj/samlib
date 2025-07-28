import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/supplies/transport_plan.dart';

class TransportSubTaskDto {
  final TransportSubTaskType type;
  final String place;
  final DateTime? dateTime;
  final String? relatedOrderId;
  final String? note;

  TransportSubTaskDto({
    required this.type,
    required this.place,
    this.dateTime,
    this.relatedOrderId,
    this.note,
  });

  factory TransportSubTaskDto.fromJson(Map<String, dynamic> json) {
    return TransportSubTaskDto(
      type: TransportSubTaskType.values.firstWhere(
        (e) => e.name == (json['type'] ?? 'other'),
        orElse: () => TransportSubTaskType.other,
      ),
      place: json['place'] as String? ?? '',
      dateTime: (json['dateTime'] as Timestamp?)?.toDate(),
      relatedOrderId: json['relatedOrderId'] as String?,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'place': place,
        'dateTime': dateTime == null ? null : Timestamp.fromDate(dateTime!),
        'relatedOrderId': relatedOrderId,
        'note': note,
      };

  TransportSubTask toDomain() => TransportSubTask(
        type: type,
        place: place,
        dateTime: dateTime,
        relatedOrderId: relatedOrderId,
        note: note,
      );

  factory TransportSubTaskDto.fromDomain(TransportSubTask task) =>
      TransportSubTaskDto(
        type: task.type,
        place: task.place,
        dateTime: task.dateTime,
        relatedOrderId: task.relatedOrderId,
        note: task.note,
      );
}

class TransportPlanDto {
  final String id;
  final String createdBy;
  final DateTime start;
  final DateTime end;
  final List<TransportSubTaskDto> subtasks;
  final String comment;
  final bool closed;

  TransportPlanDto({
    required this.id,
    required this.createdBy,
    required this.start,
    required this.end,
    this.subtasks = const [],
    this.comment = '',
    this.closed = false,
  });

  factory TransportPlanDto.fromJson(Map<String, dynamic> json) {
    return TransportPlanDto(
      id: json['id'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? '',
      start: (json['start'] as Timestamp?)?.toDate() ?? DateTime.now(),
      end: (json['end'] as Timestamp?)?.toDate() ?? DateTime.now(),
      subtasks: (json['subtasks'] as List?)
              ?.map((e) => TransportSubTaskDto.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ))
              .toList() ??
          const [],
      comment: json['comment'] as String? ?? '',
      closed: json['closed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdBy': createdBy,
        'start': Timestamp.fromDate(start),
        'end': Timestamp.fromDate(end),
        'subtasks': subtasks.map((e) => e.toJson()).toList(),
        'comment': comment,
        'closed': closed,
      };

  TransportPlan toDomain() => TransportPlan(
        id: id,
        createdBy: createdBy,
        start: start,
        end: end,
        subtasks: subtasks.map((e) => e.toDomain()).toList(),
        comment: comment,
        closed: closed,
      );

  factory TransportPlanDto.fromDomain(TransportPlan plan) => TransportPlanDto(
        id: plan.id,
        createdBy: plan.createdBy,
        start: plan.start,
        end: plan.end,
        subtasks:
            plan.subtasks.map(TransportSubTaskDto.fromDomain).toList(),
        comment: plan.comment,
        closed: plan.closed,
      );
}
