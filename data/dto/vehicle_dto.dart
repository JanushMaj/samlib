import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kabast/domain/models/vehicle.dart';

class VehicleDto {
  final String id;
  final String color;
  final String brand;
  final String model;
  final String nrRejestracyjny;
  final VehicleType type;
  final int sittingCapacity;
  final String cargoDimensions;
  final String maxLoad;

  VehicleDto({
    required this.id,
    required this.color,
    required this.brand,
    required this.model,
    required this.nrRejestracyjny,
    required this.type,
    required this.sittingCapacity,
    required this.cargoDimensions,
    required this.maxLoad,
  });

  factory VehicleDto.fromJson(Map<String, dynamic> json) {
    return VehicleDto(
      id: json['id'] as String? ?? '',
      color: json['color'] as String? ?? '',
      brand: json['brand'] as String? ?? 'Unknown',
      model: json['model'] as String? ?? 'Unknown',
      nrRejestracyjny: json['nrRejestracyjny'] as String? ?? '',
      type: _stringToVehicleType(json['type'] as String?),
      sittingCapacity: json['sittingCapacity'] is String
          ? int.tryParse(json['sittingCapacity']) ?? 0
          : (json['sittingCapacity'] as int? ?? 0),
      cargoDimensions: json['cargoDimensions'] as String? ?? '',
      maxLoad: json['maxLoad'] as String? ?? '',
    );
  }

  factory VehicleDto.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>? ?? {})..putIfAbsent('id', () => doc.id);
    return VehicleDto.fromJson(data);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'color': color,
      'brand': brand,
      'model': model,
      'nrRejestracyjny': nrRejestracyjny,
      'type': _vehicleTypeToString(type),
      'sittingCapacity': sittingCapacity,
      'cargoDimensions': cargoDimensions,
      'maxLoad': maxLoad,
    };
  }

  Vehicle toDomain() {
    return Vehicle(
      id: id,
      color: color,
      brand: brand,
      model: model,
      nrRejestracyjny: nrRejestracyjny,
      type: type,
      sittingCapacity: sittingCapacity,
      cargoDimensions: cargoDimensions,
      maxLoad: maxLoad,
    );
  }

  factory VehicleDto.fromDomain(Vehicle vehicle) {
    return VehicleDto(
      id: vehicle.id,
      color: vehicle.color,
      brand: vehicle.brand,
      model: vehicle.model,
      nrRejestracyjny: vehicle.nrRejestracyjny,
      type: vehicle.type,
      sittingCapacity: vehicle.sittingCapacity,
      cargoDimensions: vehicle.cargoDimensions,
      maxLoad: vehicle.maxLoad,
    );
  }
}

VehicleType _stringToVehicleType(String? value) {
  switch (value) {
    case 'osobowka':
      return VehicleType.osobowka;
    case 'dostawczy':
      return VehicleType.dostawczy;
    default:
      return VehicleType.osobowka;
  }
}

String _vehicleTypeToString(VehicleType type) {
  switch (type) {
    case VehicleType.osobowka:
      return 'osobowka';
    case VehicleType.dostawczy:
      return 'dostawczy';
  }
}
