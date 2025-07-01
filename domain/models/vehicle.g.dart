// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
      id: json['id'] as String? ?? '',
      color: json['color'] as String? ?? '',
      brand: json['brand'] as String? ?? 'Unknown',
      model: json['model'] as String? ?? 'Unknown',
      nrRejestracyjny: json['nrRejestracyjny'] as String? ?? '',
      type: $enumDecodeNullable(_$VehicleTypeEnumMap, json['type']) ??
          VehicleType.osobowka,
      sittingCapacity: json['sittingCapacity'] is String
          ? int.tryParse(json['sittingCapacity']) ?? 0
          : (json['sittingCapacity'] as int? ?? 0),
      cargoDimensions: json['cargoDimensions'] as String? ?? '',
      maxLoad: json['maxLoad'] as String? ?? '',
    );

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
      'id': instance.id,
      'color': instance.color,
      'brand': instance.brand,
      'model': instance.model,
      'nrRejestracyjny': instance.nrRejestracyjny,
      'type': _$VehicleTypeEnumMap[instance.type]!,
      'sittingCapacity': instance.sittingCapacity,
      'cargoDimensions': instance.cargoDimensions,
      'maxLoad': instance.maxLoad,
    };

const Map<VehicleType, String> _$VehicleTypeEnumMap = {
  VehicleType.osobowka: 'osobowka',
  VehicleType.dostawczy: 'dostawczy',
};
