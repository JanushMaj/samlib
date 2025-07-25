import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/grafik/impl/task_planning_element.dart';
import '../../../domain/models/grafik/enums.dart';
import 'grafik_element_dto.dart';

class TaskPlanningElementDto extends GrafikElementDto {
  final int workerCount;
  final String orderId;
  final GrafikProbability probability;
  final GrafikTaskType taskType;
  final int minutes;
  final bool highPriority;
  final bool isPending;
  final List<String> plannedWorkerIds;

  TaskPlanningElementDto({
    required super.id,
    required super.startDateTime,
    required super.endDateTime,
    required super.type,
    required super.additionalInfo,
    required super.addedByUserId,
    required super.addedTimestamp,
    required super.closed,
    required this.workerCount,
    required this.orderId,
    required this.probability,
    required this.taskType,
    required this.minutes,
    required this.highPriority,
    this.isPending = false,
    this.plannedWorkerIds = const [],
  });

  factory TaskPlanningElementDto.fromJson(Map<String, dynamic> json) {
    return TaskPlanningElementDto(
      id: json['id'] as String? ?? '',
      startDateTime: GrafikElementDto.parseDateTime(
        json['startDateTime'],
        DateTime.now(),
      ),
      endDateTime: GrafikElementDto.parseDateTime(
        json['endDateTime'],
        DateTime.now(),
      ),
      type: 'TaskPlanningElement',
      additionalInfo: json['additionalInfo'] as String? ?? '',
      addedByUserId: json['addedByUserId'] as String? ?? '',
      addedTimestamp: GrafikElementDto.parseDateTime(
        json['addedTimestamp'],
        DateTime(1960, 2, 9),
      ),
      closed: json['closed'] as bool? ?? false,
      workerCount: json['workerCount'] as int? ?? 1,
      orderId: json['orderId'] as String? ?? '',
      probability: GrafikProbability.values.firstWhere(
        (e) => e.name == (json['probability'] ?? 'Pewne'),
        orElse: () => GrafikProbability.Pewne,
      ),
      taskType: GrafikTaskType.values.firstWhere(
        (e) => e.name == (json['taskType'] ?? 'Inne'),
        orElse: () => GrafikTaskType.Inne,
      ),
      minutes: json['minutes'] as int? ?? 60,
      highPriority: json['highPriority'] as bool? ?? false,
      isPending: json['isPending'] as bool? ?? false,
      plannedWorkerIds:
          (json['plannedWorkerIds'] as List?)?.cast<String>() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
        ...baseToJson(),
        'workerCount': workerCount,
        'orderId': orderId,
        'probability': probability.name,
        'taskType': taskType.name,
        'minutes': minutes,
        'highPriority': highPriority,
        'isPending': isPending,
        'plannedWorkerIds': plannedWorkerIds,
      };

  TaskPlanningElement toDomain() => TaskPlanningElement(
        id: id,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        additionalInfo: additionalInfo,
        workerCount: workerCount,
        orderId: orderId,
        probability: probability,
        taskType: taskType,
        minutes: minutes,
        highPriority: highPriority,
        addedByUserId: addedByUserId,
        addedTimestamp: addedTimestamp,
        closed: closed,
        isPending: isPending,
        plannedWorkerIds: plannedWorkerIds,
      );

  static TaskPlanningElementDto fromDomain(TaskPlanningElement element) =>
      TaskPlanningElementDto(
        id: element.id,
        startDateTime: element.startDateTime,
        endDateTime: element.endDateTime,
        type: element.type,
        additionalInfo: element.additionalInfo,
        addedByUserId: element.addedByUserId,
        addedTimestamp: element.addedTimestamp,
        closed: element.closed,
        workerCount: element.workerCount,
        orderId: element.orderId,
        probability: element.probability,
        taskType: element.taskType,
        minutes: element.minutes,
        highPriority: element.highPriority,
        isPending: element.isPending,
        plannedWorkerIds: List<String>.from(element.plannedWorkerIds),
      );
}
