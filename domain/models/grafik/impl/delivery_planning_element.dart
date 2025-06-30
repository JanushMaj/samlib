import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums.dart';
import '../grafik_element.dart';

/// Element planowania dostaw.
class DeliveryPlanningElement extends GrafikElement {
  final String orderId;
  final DeliveryPlanningCategory category;

  DeliveryPlanningElement({
    required String id,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required String additionalInfo,
    required this.orderId,
    required this.category,
    required String addedByUserId,
    required DateTime addedTimestamp,
    required bool closed,
  }) : super(
    id: id,
    startDateTime: startDateTime,
    endDateTime: endDateTime,
    type: 'DeliveryPlanningElement',
    additionalInfo: additionalInfo,
    addedByUserId: addedByUserId,
    addedTimestamp: addedTimestamp,
    closed: closed,
  );

  @override
  Map<String, dynamic> toJson() {
    final base = baseToJson();
    return {
      ...base,
      'orderId': orderId,
      'category': category.toString(),
    };
  }

  factory DeliveryPlanningElement.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] as String?) ?? '';
    final startTs = json['startDateTime'] as Timestamp?;
    final endTs = json['endDateTime'] as Timestamp?;
    final additionalInfo = (json['additionalInfo'] as String?) ?? '';
    final addedByUserId = (json['addedByUserId'] as String?) ?? '';
    final addedTimestamp = (json['addedTimestamp'] as Timestamp?)?.toDate() ?? DateTime(1960, 2, 9);
    final closed = (json['closed'] as bool?) ?? false;

    final orderId = (json['orderId'] as String?) ?? '';
    final categoryStr = (json['category'] as String?) ?? 'DeliveryPlanningCategory.Inne';
    final category = DeliveryPlanningCategory.values.firstWhere(
          (e) => e.toString() == categoryStr,
      orElse: () => DeliveryPlanningCategory.Inne,
    );

    return DeliveryPlanningElement(
      id: id,
      startDateTime: startTs?.toDate() ?? DateTime.now(),
      endDateTime: endTs?.toDate() ?? DateTime.now(),
      additionalInfo: additionalInfo,
      orderId: orderId,
      category: category,
      addedByUserId: addedByUserId,
      addedTimestamp: addedTimestamp,
      closed: closed,
    );
  }
}
