class SupplyOrder {
  final String id;
  final String itemId;
  final String orderedBy;
  final DateTime orderedAt;
  final int quantityRequested;
  final String status;

  SupplyOrder({
    required this.id,
    required this.itemId,
    required this.orderedBy,
    required this.orderedAt,
    required this.quantityRequested,
    required this.status,
  });
}
