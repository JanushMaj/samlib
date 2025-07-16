import '../models/supply_item.dart';
import '../models/supply_order.dart';

abstract class ISupplyRepository {
  Stream<List<SupplyItem>> watchItems();
  Future<void> saveItem(SupplyItem item);

  Future<void> placeOrder(SupplyOrder order);

  Stream<List<SupplyOrder>> watchOrders();
}
