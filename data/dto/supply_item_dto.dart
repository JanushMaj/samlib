import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/supply_item.dart';

class SupplyItemDto {
  final String id;
  final String name;
  final String category;
  final int quantityAvailable;
  final String unit;
  final DateTime? lastOrderedAt;
  final int lowStockThreshold;

  SupplyItemDto({
    required this.id,
    required this.name,
    required this.category,
    required this.quantityAvailable,
    required this.unit,
    required this.lastOrderedAt,
    required this.lowStockThreshold,
  });

  factory SupplyItemDto.fromJson(Map<String, dynamic> json) {
    return SupplyItemDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      quantityAvailable: (json['quantityAvailable'] as num?)?.toInt() ?? 0,
      unit: json['unit'] as String? ?? '',
      lastOrderedAt: (json['lastOrderedAt'] as Timestamp?)?.toDate(),
      lowStockThreshold: (json['lowStockThreshold'] as num?)?.toInt() ?? 0,
    );
  }

  factory SupplyItemDto.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>? ?? {})..putIfAbsent('id', () => doc.id);
    return SupplyItemDto.fromJson(data);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantityAvailable': quantityAvailable,
      'unit': unit,
      'lastOrderedAt': lastOrderedAt == null ? null : Timestamp.fromDate(lastOrderedAt!),
      'lowStockThreshold': lowStockThreshold,
    };
  }

  SupplyItem toDomain() {
    return SupplyItem(
      id: id,
      name: name,
      category: category,
      quantityAvailable: quantityAvailable,
      unit: unit,
      lastOrderedAt: lastOrderedAt,
      lowStockThreshold: lowStockThreshold,
    );
  }

  factory SupplyItemDto.fromDomain(SupplyItem item) {
    return SupplyItemDto(
      id: item.id,
      name: item.name,
      category: item.category,
      quantityAvailable: item.quantityAvailable,
      unit: item.unit,
      lastOrderedAt: item.lastOrderedAt,
      lowStockThreshold: item.lowStockThreshold,
    );
  }
}
