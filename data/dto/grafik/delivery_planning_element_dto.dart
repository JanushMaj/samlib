import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/grafik/impl/delivery_planning_element.dart';
import '../../../domain/models/grafik/enums.dart';
import 'grafik_element_dto.dart';

class DeliveryPlanningElementDto extends GrafikElementDto {
  final String orderId;
  final DeliveryPlanningCategory category;

  DeliveryPlanningElementDto({
    required super.id,
    required super.startDateTime,
    required super.endDateTime,
    required super.type,
    required super.additionalInfo,
    required super.addedByUserId,
    required super.addedTimestamp,
    required super.closed,
    required this.orderId,
    required this.category,
  });

  factory DeliveryPlanningElementDto.fromJson(Map<String, dynamic> json) {
    final categoryStr = json['category'] as String? ??
        'DeliveryPlanningCategory.Inne';
    return DeliveryPlanningElementDto(
      id: json['id'] as String? ?? '',
      startDateTime: GrafikElementDto.parseDateTime(
        json['startDateTime'],
        DateTime.now(),
      ),
      endDateTime: GrafikElementDto.parseDateTime(
        json['endDateTime'],
        DateTime.now(),
      ),
      type: 'DeliveryPlanningElement',
      additionalInfo: json['additionalInfo'] as String? ?? '',
      addedByUserId: json['addedByUserId'] as String? ?? '',
      addedTimestamp: GrafikElementDto.parseDateTime(
        json['addedTimestamp'],
        DateTime(1960, 2, 9),
      ),
      closed: json['closed'] as bool? ?? false,
      orderId: json['orderId'] as String? ?? '',
      category: DeliveryPlanningCategory.values.firstWhere(
        (e) => e.toString() == categoryStr,
        orElse: () => DeliveryPlanningCategory.Inne,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        ...baseToJson(),
        'orderId': orderId,
        'category': category.toString(),
      };

  DeliveryPlanningElement toDomain() => DeliveryPlanningElement(
        id: id,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        additionalInfo: additionalInfo,
        orderId: orderId,
        category: category,
        addedByUserId: addedByUserId,
        addedTimestamp: addedTimestamp,
        closed: closed,
      );

  static DeliveryPlanningElementDto fromDomain(DeliveryPlanningElement element) =>
      DeliveryPlanningElementDto(
        id: element.id,
        startDateTime: element.startDateTime,
        endDateTime: element.endDateTime,
        type: element.type,
        additionalInfo: element.additionalInfo,
        addedByUserId: element.addedByUserId,
        addedTimestamp: element.addedTimestamp,
        closed: element.closed,
        orderId: element.orderId,
        category: element.category,
      );
}
