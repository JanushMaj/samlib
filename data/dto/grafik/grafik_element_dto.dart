import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/grafik/grafik_element.dart';
import '../../../domain/models/grafik/impl/task_element.dart';
import '../../../domain/models/grafik/impl/time_issue_element.dart';
import '../../../domain/models/grafik/impl/delivery_planning_element.dart';
import '../../../domain/models/grafik/impl/task_planning_element.dart';
import '../../../domain/models/grafik/impl/supply_run_element.dart';
import '../../../domain/models/grafik/impl/service_request_element.dart';
import '../../../domain/models/grafik/enums.dart';
import 'task_element_dto.dart';
import 'time_issue_element_dto.dart';
import 'delivery_planning_element_dto.dart';
import 'task_planning_element_dto.dart';
import 'supply_run_element_dto.dart';
import 'service_request_element_dto.dart';

abstract class GrafikElementDto {
  static DateTime parseDateTime(dynamic value, DateTime fallback) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    if (value is String) {
      return DateTime.tryParse(value) ?? fallback;
    }
    return fallback;
  }
  final String id;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String type;
  final String additionalInfo;
  final String addedByUserId;
  final DateTime addedTimestamp;
  final bool closed;

  GrafikElementDto({
    required this.id,
    required this.startDateTime,
    required this.endDateTime,
    required this.type,
    required this.additionalInfo,
    required this.addedByUserId,
    required this.addedTimestamp,
    required this.closed,
  });

  Map<String, dynamic> toJson();

  GrafikElement toDomain();

  Map<String, dynamic> baseToJson() => {
        'id': id,
        'startDateTime': Timestamp.fromDate(startDateTime),
        'endDateTime': Timestamp.fromDate(endDateTime),
        'type': type,
        'additionalInfo': additionalInfo,
        'addedByUserId': addedByUserId,
        'addedTimestamp': Timestamp.fromDate(addedTimestamp),
        'closed': closed,
      };

  static GrafikElementDto fromDomain(GrafikElement element) {
    switch (element.type) {
      case 'TaskElement':
        return TaskElementDto.fromDomain(element as TaskElement);
      case 'TimeIssueElement':
        return TimeIssueElementDto.fromDomain(element as TimeIssueElement);
      case 'DeliveryPlanningElement':
        return DeliveryPlanningElementDto.fromDomain(
            element as DeliveryPlanningElement);
      case 'SupplyRunElement':
        return SupplyRunElementDto.fromDomain(
            element as SupplyRunElement);
      case 'ServiceRequestElement':
        return ServiceRequestElementDto.fromDomain(
            element as ServiceRequestElement);
      case 'TaskPlanningElement':
        return TaskPlanningElementDto.fromDomain(
            element as TaskPlanningElement);
      default:
        throw Exception('Unknown element type: ${element.type}');
    }
  }

  static GrafikElementDto fromJson(Map<String, dynamic> json) {
    final type = json['type']?.toString() ?? '';
    switch (type) {
      case 'TaskElement':
        return TaskElementDto.fromJson(json);
      case 'TimeIssueElement':
        return TimeIssueElementDto.fromJson(json);
      case 'DeliveryPlanningElement':
        return DeliveryPlanningElementDto.fromJson(json);
      case 'SupplyRunElement':
        return SupplyRunElementDto.fromJson(json);
      case 'ServiceRequestElement':
        return ServiceRequestElementDto.fromJson(json);
      case 'TaskPlanningElement':
        return TaskPlanningElementDto.fromJson(json);
      default:
        return TimeIssueElementDto.fromJson({
          ...json,
          'type': 'TimeIssueElement',
          'additionalInfo': 'Nieznany typ: $type',
        });
    }
  }

  static GrafikElementDto fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return fromJson(data);
  }
}
