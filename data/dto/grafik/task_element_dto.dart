import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/grafik/impl/task_element.dart';
import '../../../domain/models/grafik/enums.dart';
import 'grafik_element_dto.dart';

class TaskElementDto extends GrafikElementDto {
  final List<String> workerIds;
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
    required this.workerIds,
    required this.orderId,
    required this.status,
    required this.taskType,
    required this.carIds,
  });

  factory TaskElementDto.fromJson(Map<String, dynamic> json) {
    return TaskElementDto(
      id: json['id'] as String? ?? '',
      startDateTime: (json['startDateTime'] as Timestamp?)?.toDate() ??
          DateTime.now(),
      endDateTime: (json['endDateTime'] as Timestamp?)?.toDate() ??
          DateTime.now(),
      type: 'TaskElement',
      additionalInfo: json['additionalInfo'] as String? ?? '',
      addedByUserId: json['addedByUserId'] as String? ?? '',
      addedTimestamp:
          (json['addedTimestamp'] as Timestamp?)?.toDate() ?? DateTime(1960, 2, 9),
      closed: json['closed'] as bool? ?? false,
      workerIds: (json['workerIds'] as List?)?.cast<String>() ?? <String>[],
      orderId: json['orderId'] as String? ?? '',
      status: GrafikStatus.values.firstWhere(
        (e) => e.toString() == (json['status'] ?? 'GrafikStatus.Realizacja'),
        orElse: () => GrafikStatus.Realizacja,
      ),
      taskType: GrafikTaskType.values.firstWhere(
        (e) => e.toString() == (json['taskType'] ?? 'GrafikTaskType.Inne'),
        orElse: () => GrafikTaskType.Inne,
      ),
      carIds: (json['carIds'] as List?)?.cast<String>() ?? <String>[],
    );
  }

  Map<String, dynamic> toJson() => {
        ...baseToJson(),
        'workerIds': workerIds,
        'orderId': orderId,
        'status': status.toString(),
        'taskType': taskType.toString(),
        'carIds': carIds,
      };

  TaskElement toDomain() => TaskElement(
        id: id,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        additionalInfo: additionalInfo,
        workerIds: workerIds,
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
        workerIds: List<String>.from(element.workerIds),
        orderId: element.orderId,
        status: element.status,
        taskType: element.taskType,
        carIds: List<String>.from(element.carIds),
      );
}
