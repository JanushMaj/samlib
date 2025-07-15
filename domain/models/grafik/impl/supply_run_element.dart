import '../grafik_element.dart';

/// Element planowanej trasy zaopatrzenia tworzony przez użytkownika.
class SupplyRunElement extends GrafikElement {
  final List<String> supplyOrderIds;
  final String routeDescription;

  SupplyRunElement({
    required String id,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required String additionalInfo,
    required this.supplyOrderIds,
    required this.routeDescription,
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
        addedByUserId: addedByUserId,
        addedTimestamp: addedTimestamp,
        closed: closed,
      );
}
