import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/store.dart';

class StoreDto {
  final String id;
  final String name;
  final String defaultAddress;
  final bool isDefaultListFlag;

  StoreDto({
    required this.id,
    required this.name,
    required this.defaultAddress,
    required this.isDefaultListFlag,
  });

  factory StoreDto.fromJson(Map<String, dynamic> json) {
    return StoreDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      defaultAddress: json['defaultAddress'] as String? ?? '',
      isDefaultListFlag: json['isDefaultListFlag'] as bool? ?? false,
    );
  }

  factory StoreDto.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>? ?? {})..putIfAbsent('id', () => doc.id);
    return StoreDto.fromJson(data);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'defaultAddress': defaultAddress,
      'isDefaultListFlag': isDefaultListFlag,
    };
  }

  Store toDomain() {
    return Store(
      id: id,
      name: name,
      defaultAddress: defaultAddress,
      isDefaultListFlag: isDefaultListFlag,
    );
  }

  factory StoreDto.fromDomain(Store store) {
    return StoreDto(
      id: store.id,
      name: store.name,
      defaultAddress: store.defaultAddress,
      isDefaultListFlag: store.isDefaultListFlag,
    );
  }
}
