class SupplyItem {
  final String id;
  final String name;
  final String category;
  final int quantityAvailable;
  final String unit;
  final DateTime? lastOrderedAt;
  final int lowStockThreshold;

  SupplyItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantityAvailable,
    required this.unit,
    required this.lastOrderedAt,
    required this.lowStockThreshold,
  });

  bool get isLowStock => quantityAvailable < lowStockThreshold;
}
