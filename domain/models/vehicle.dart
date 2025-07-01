import 'package:json_annotation/json_annotation.dart';

part 'vehicle.g.dart';

enum VehicleType { osobowka, dostawczy }

@JsonSerializable()
class Vehicle {
  final String id;
  final String color;
  final String brand;
  final String model;
  final String nrRejestracyjny;
  final VehicleType type;
  final int sittingCapacity;
  final String cargoDimensions;
  final String maxLoad;

  Vehicle({
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

  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleToJson(this);
}
