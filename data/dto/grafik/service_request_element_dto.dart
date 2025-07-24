import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/grafik/impl/service_request_element.dart';
import '../../../domain/models/grafik/enums.dart';
import 'grafik_element_dto.dart';

class ServiceRequestElementDto extends GrafikElementDto {
  final String location;
  final String description;
  final String orderNumber;
  final ServiceUrgency urgency;
  final DateTime? suggestedDate;
  final int estimatedDurationMinutes;
  final int requiredPeopleCount;
  final GrafikTaskType taskType;

  ServiceRequestElementDto({
    required super.id,
    required super.startDateTime,
    required super.endDateTime,
    required super.type,
    required super.additionalInfo,
    required super.addedByUserId,
    required super.addedTimestamp,
    required super.closed,
    required this.location,
    required this.description,
    required this.orderNumber,
    required this.urgency,
    this.suggestedDate,
    required this.estimatedDurationMinutes,
    required this.requiredPeopleCount,
    required this.taskType,
  });

  factory ServiceRequestElementDto.fromJson(Map<String, dynamic> json) {
    return ServiceRequestElementDto(
      id: json['id'] as String? ?? '',
      startDateTime: GrafikElementDto.parseDateTime(
        json['startDateTime'],
        DateTime.now(),
      ),
      endDateTime: GrafikElementDto.parseDateTime(
        json['endDateTime'],
        DateTime.now(),
      ),
      type: 'ServiceRequestElement',
      additionalInfo: json['additionalInfo'] as String? ?? '',
      addedByUserId: json['addedByUserId'] as String? ?? '',
      addedTimestamp: GrafikElementDto.parseDateTime(
        json['addedTimestamp'],
        DateTime(1960, 2, 9),
      ),
      closed: json['closed'] as bool? ?? false,
      location: json['location'] as String? ?? '',
      description: json['description'] as String? ?? '',
      orderNumber: json['orderNumber'] as String? ?? '',
      urgency: ServiceUrgency.values.firstWhere(
        (e) => e.name == (json['urgency'] ?? 'normal'),
        orElse: () => ServiceUrgency.normal,
      ),
      suggestedDate: json['suggestedDate'] != null
          ? GrafikElementDto.parseDateTime(json['suggestedDate'], DateTime.now())
          : null,
      estimatedDurationMinutes: json['estimatedDuration'] as int? ?? 0,
      requiredPeopleCount: json['requiredPeopleCount'] as int? ?? 1,
      taskType: GrafikTaskType.values.firstWhere(
        (e) => e.name == (json['taskType'] ?? 'Serwis'),
        orElse: () => GrafikTaskType.Serwis,
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...baseToJson(),
        'location': location,
        'description': description,
        'orderNumber': orderNumber,
        'urgency': urgency.name,
        'suggestedDate':
            suggestedDate != null ? Timestamp.fromDate(suggestedDate!) : null,
        'estimatedDuration': estimatedDurationMinutes,
        'requiredPeopleCount': requiredPeopleCount,
        'taskType': taskType.name,
      };

  @override
  ServiceRequestElement toDomain() => ServiceRequestElement(
        id: id,
        createdBy: addedByUserId,
        createdAt: addedTimestamp,
        location: location,
        description: description,
        orderNumber: orderNumber,
        urgency: urgency,
        suggestedDate: suggestedDate,
        estimatedDuration: Duration(minutes: estimatedDurationMinutes),
        requiredPeopleCount: requiredPeopleCount,
        taskType: taskType,
      );

  static ServiceRequestElementDto fromDomain(ServiceRequestElement element) =>
      ServiceRequestElementDto(
        id: element.id,
        startDateTime: element.startDateTime,
        endDateTime: element.endDateTime,
        type: element.type,
        additionalInfo: element.additionalInfo,
        addedByUserId: element.addedByUserId,
        addedTimestamp: element.addedTimestamp,
        closed: element.closed,
        location: element.location,
        description: element.description,
        orderNumber: element.orderNumber,
        urgency: element.urgency,
        suggestedDate: element.suggestedDate,
        estimatedDurationMinutes: element.estimatedDuration.inMinutes,
        requiredPeopleCount: element.requiredPeopleCount,
        taskType: element.taskType,
      );

  static ServiceRequestElementDto fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return ServiceRequestElementDto.fromJson(data);
  }
}
