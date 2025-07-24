import '../models/supply_order.dart';

/// Defines integration with an external warehouse system.
abstract class IWarehouseService {
  Future<void> sendOrder(SupplyOrder order);
}
