import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/supply_order.dart';

class SupplyOrderDto {
  final String id;
  final String itemId;
  final String orderedBy;
  final DateTime orderedAt;
  final int quantityRequested;
  final String status;

  SupplyOrderDto({
    required this.id,
    required this.itemId,
    required this.orderedBy,
    required this.orderedAt,
    required this.quantityRequested,
    required this.status,
  });

  factory SupplyOrderDto.fromJson(Map<String, dynamic> json) {
    return SupplyOrderDto(
      id: json['id'] as String? ?? '',
      itemId: json['itemId'] as String? ?? '',
      orderedBy: json['orderedBy'] as String? ?? '',
      orderedAt: (json['orderedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      quantityRequested: (json['quantityRequested'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'pending',
    );
  }

  factory SupplyOrderDto.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>? ?? {})..putIfAbsent('id', () => doc.id);
    return SupplyOrderDto.fromJson(data);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemId': itemId,
      'orderedBy': orderedBy,
      'orderedAt': Timestamp.fromDate(orderedAt),
      'quantityRequested': quantityRequested,
      'status': status,
    };
  }

  SupplyOrder toDomain() {
    return SupplyOrder(
      id: id,
      itemId: itemId,
      orderedBy: orderedBy,
      orderedAt: orderedAt,
      quantityRequested: quantityRequested,
      status: status,
    );
  }

  factory SupplyOrderDto.fromDomain(SupplyOrder order) {
    return SupplyOrderDto(
      id: order.id,
      itemId: order.itemId,
      orderedBy: order.orderedBy,
      orderedAt: order.orderedAt,
      quantityRequested: order.quantityRequested,
      status: order.status,
    );
  }
}
