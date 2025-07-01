// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_element.dart';

TaskElement _$TaskElementFromJson(Map<String, dynamic> json) => TaskElement(
      id: json['id'] as String? ?? '',
      startDateTime: (json['startDateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDateTime: (json['endDateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      additionalInfo: json['additionalInfo'] as String? ?? '',
      workerIds: (json['workerIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? <String>[],
      orderId: json['orderId'] as String? ?? '',
      status: $enumDecodeNullable(_$GrafikStatusEnumMap, json['status']) ?? GrafikStatus.Realizacja,
      taskType: $enumDecodeNullable(_$GrafikTaskTypeEnumMap, json['taskType']) ?? GrafikTaskType.Inne,
      carIds: (json['carIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? <String>[],
      addedByUserId: json['addedByUserId'] as String? ?? '',
      addedTimestamp: (json['addedTimestamp'] as Timestamp?)?.toDate() ?? DateTime(1960, 2, 9),
      closed: json['closed'] as bool? ?? false,
    );

Map<String, dynamic> _$TaskElementToJson(TaskElement instance) => <String, dynamic>{
      ...instance.baseToJson(),
      'workerIds': instance.workerIds,
      'orderId': instance.orderId,
      'status': _$GrafikStatusEnumMap[instance.status]!,
      'taskType': _$GrafikTaskTypeEnumMap[instance.taskType]!,
      'carIds': instance.carIds,
    };

const Map<GrafikStatus, String> _$GrafikStatusEnumMap = {
  GrafikStatus.Realizacja: 'GrafikStatus.Realizacja',
  GrafikStatus.Wstrzymane: 'GrafikStatus.Wstrzymane',
  GrafikStatus.Zakonczone: 'GrafikStatus.Zakonczone',
  GrafikStatus.Anulowane: 'GrafikStatus.Anulowane',
};

const Map<GrafikTaskType, String> _$GrafikTaskTypeEnumMap = {
  GrafikTaskType.Serwis: 'GrafikTaskType.Serwis',
  GrafikTaskType.Produkcja: 'GrafikTaskType.Produkcja',
  GrafikTaskType.Budowa: 'GrafikTaskType.Budowa',
  GrafikTaskType.Inne: 'GrafikTaskType.Inne',
};
