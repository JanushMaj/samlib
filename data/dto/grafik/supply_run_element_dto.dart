import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/grafik/impl/supply_run_element.dart';
import 'grafik_element_dto.dart';

class SupplyRunElementDto extends GrafikElementDto {
  final List<String> supplyOrderIds;
  final String routeDescription;
  final List<String> vehicleIds;
  final List<String> driverIds;

  SupplyRunElementDto({
    required super.id,
    required super.startDateTime,
    required super.endDateTime,
    required super.type,
    required super.additionalInfo,
    required super.addedByUserId,
    required super.addedTimestamp,
    required super.closed,
    required this.supplyOrderIds,
    required this.routeDescription,
    this.vehicleIds = const [],
    this.driverIds = const [],
  });

  factory SupplyRunElementDto.fromJson(Map<String, dynamic> json) {
    return SupplyRunElementDto(
      id: json['id'] as String? ?? '',
      startDateTime: GrafikElementDto.parseDateTime(
        json['startDateTime'],
        DateTime.now(),
      ),
      endDateTime: GrafikElementDto.parseDateTime(
        json['endDateTime'],
        DateTime.now(),
      ),
      type: 'SupplyRunElement',
      additionalInfo: json['additionalInfo'] as String? ?? '',
      addedByUserId: json['addedByUserId'] as String? ?? '',
      addedTimestamp: GrafikElementDto.parseDateTime(
        json['addedTimestamp'],
        DateTime(1960, 2, 9),
      ),
      closed: json['closed'] as bool? ?? false,
      supplyOrderIds:
          (json['supplyOrderIds'] as List?)?.cast<String>() ?? const <String>[],
      routeDescription: json['routeDescription'] as String? ?? '',
      vehicleIds: (json['vehicleIds'] as List?)?.cast<String>() ?? const <String>[],
      driverIds: (json['driverIds'] as List?)?.cast<String>() ?? const <String>[],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...baseToJson(),
        'supplyOrderIds': supplyOrderIds,
        'routeDescription': routeDescription,
        'vehicleIds': vehicleIds,
        'driverIds': driverIds,
      };

  @override
  SupplyRunElement toDomain() => SupplyRunElement(
        id: id,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        additionalInfo: additionalInfo,
        supplyOrderIds: supplyOrderIds,
        routeDescription: routeDescription,
        vehicleIds: vehicleIds,
        driverIds: driverIds,
        addedByUserId: addedByUserId,
        addedTimestamp: addedTimestamp,
        closed: closed,
      );

  static SupplyRunElementDto fromDomain(SupplyRunElement element) =>
      SupplyRunElementDto(
        id: element.id,
        startDateTime: element.startDateTime,
        endDateTime: element.endDateTime,
        type: element.type,
        additionalInfo: element.additionalInfo,
        addedByUserId: element.addedByUserId,
        addedTimestamp: element.addedTimestamp,
        closed: element.closed,
        supplyOrderIds: List<String>.from(element.supplyOrderIds),
        routeDescription: element.routeDescription,
        vehicleIds: List<String>.from(element.vehicleIds),
        driverIds: List<String>.from(element.driverIds),
      );
}
