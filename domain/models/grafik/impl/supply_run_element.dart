import '../grafik_element.dart';

/// Element planowanej trasy zaopatrzenia tworzony przez użytkownika.
class SupplyRunElement extends GrafikElement {
  final List<String> supplyOrderIds;
  final String routeDescription;
  final List<String> vehicleIds;
  final List<String> driverIds;

  SupplyRunElement({
    required String id,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required String additionalInfo,
    required this.supplyOrderIds,
    required this.routeDescription,
    this.vehicleIds = const [],
    this.driverIds = const [],
    required String addedByUserId,
    required DateTime addedTimestamp,
    bool closed = false,
  }) : super(
          id: id,
          startDateTime: startDateTime,
          endDateTime: endDateTime,
          type: 'SupplyRunElement',
          additionalInfo: additionalInfo,
          addedByUserId: addedByUserId,
          addedTimestamp: addedTimestamp,
          closed: closed,
        );

  SupplyRunElement copyWith({
    String? id,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? additionalInfo,
    List<String>? supplyOrderIds,
    String? routeDescription,
    List<String>? vehicleIds,
    List<String>? driverIds,
    String? addedByUserId,
    DateTime? addedTimestamp,
    bool? closed,
  }) {
    return SupplyRunElement(
      id: id ?? this.id,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      supplyOrderIds: supplyOrderIds ?? List<String>.from(this.supplyOrderIds),
      routeDescription: routeDescription ?? this.routeDescription,
      vehicleIds: vehicleIds ?? List<String>.from(this.vehicleIds),
      driverIds: driverIds ?? List<String>.from(this.driverIds),
      addedByUserId: addedByUserId ?? this.addedByUserId,
      addedTimestamp: addedTimestamp ?? this.addedTimestamp,
      closed: closed ?? this.closed,
    );
  }

  SupplyRunElement copyWithId(String newId) => SupplyRunElement(
        id: newId,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        additionalInfo: additionalInfo,
        supplyOrderIds: List<String>.from(supplyOrderIds),
        routeDescription: routeDescription,
        vehicleIds: List<String>.from(vehicleIds),
        driverIds: List<String>.from(driverIds),
        addedByUserId: addedByUserId,
        addedTimestamp: addedTimestamp,
        closed: closed,
      );
}
