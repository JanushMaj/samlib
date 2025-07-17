import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/grafik/impl/task_element.dart';
import '../../../domain/models/grafik/enums.dart';
import 'grafik_element_dto.dart';

class TaskElementDto extends GrafikElementDto {
  final String orderId;
  final GrafikStatus status;
  final GrafikTaskType taskType;
  final List<String> carIds;

  TaskElementDto({
    required super.id,
    required super.startDateTime,
    required super.endDateTime,
    required super.type,
    required super.additionalInfo,
    required super.addedByUserId,
    required super.addedTimestamp,
    required super.closed,
    required this.orderId,
    required this.status,
    required this.taskType,
    required this.carIds,
  });

  factory TaskElementDto.fromJson(Map<String, dynamic> json) {
    return TaskElementDto(
      id: json['id'] as String? ?? '',
      startDateTime: GrafikElementDto.parseDateTime(
        json['startDateTime'],
        DateTime.now(),
      ),
      endDateTime: GrafikElementDto.parseDateTime(
        json['endDateTime'],
        DateTime.now(),
      ),
      type: 'TaskElement',
      additionalInfo: json['additionalInfo'] as String? ?? '',
      addedByUserId: json['addedByUserId'] as String? ?? '',
      addedTimestamp: GrafikElementDto.parseDateTime(
        json['addedTimestamp'],
        DateTime(1960, 2, 9),
      ),
      closed: json['closed'] as bool? ?? false,
      orderId: json['orderId'] as String? ?? '',
      status: GrafikStatus.values.firstWhere(
        (e) => e.name == (json['status'] ?? 'Realizacja'),
        orElse: () => GrafikStatus.Realizacja,
      ),
      taskType: GrafikTaskType.values.firstWhere(
        (e) => e.name == (json['taskType'] ?? 'Inne'),
        orElse: () => GrafikTaskType.Inne,
      ),
      carIds: (json['carIds'] as List?)?.cast<String>() ?? <String>[],
    );
  }

  Map<String, dynamic> toJson() => {
        ...baseToJson(),
        'orderId': orderId,
        'status': status.name,
        'taskType': taskType.name,
        'carIds': carIds,
      };

  TaskElement toDomain() => TaskElement(
        id: id,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        additionalInfo: additionalInfo,
        orderId: orderId,
        status: status,
        taskType: taskType,
        carIds: carIds,
        addedByUserId: addedByUserId,
        addedTimestamp: addedTimestamp,
        closed: closed,
      );

  static TaskElementDto fromDomain(TaskElement element) => TaskElementDto(
        id: element.id,
        startDateTime: element.startDateTime,
        endDateTime: element.endDateTime,
        type: element.type,
        additionalInfo: element.additionalInfo,
        addedByUserId: element.addedByUserId,
        addedTimestamp: element.addedTimestamp,
        closed: element.closed,
        orderId: element.orderId,
        status: element.status,
        taskType: element.taskType,
        carIds: List<String>.from(element.carIds),
      );
}
