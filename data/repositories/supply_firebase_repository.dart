import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/supply_item.dart';
import '../../domain/models/supply_order.dart';
import '../../domain/services/i_supply_repository.dart';
import '../dto/supply_item_dto.dart';
import '../dto/supply_order_dto.dart';

class SupplyFirebaseRepository implements ISupplyRepository {
  final FirebaseFirestore _firestore;

  SupplyFirebaseRepository(this._firestore);

  CollectionReference get _items => _firestore.collection('supplies');
  CollectionReference get _orders => _firestore.collection('supply_orders');

  @override
  Stream<List<SupplyItem>> watchItems() {
    // TODO: Replace with Firestore integration
    return Stream<List<SupplyItem>>.empty();
  }

  @override
  Future<void> saveItem(SupplyItem item) async {
    final dto = SupplyItemDto.fromDomain(item);
    if (item.id.isEmpty) {
      final ref = await _items.add(dto.toJson());
      await ref.update({'id': ref.id});
    } else {
      await _items.doc(item.id).set(dto.toJson());
    }
  }

  @override
  Future<void> placeOrder(SupplyOrder order) async {
    final dto = SupplyOrderDto.fromDomain(order);
    await _orders.add(dto.toJson());
    // TODO: Integrate with external warehouse system via adapter
  }

  @override
  Stream<List<SupplyOrder>> watchOrders() {
    return _orders.snapshots().map((query) =>
        query.docs.map((doc) => SupplyOrderDto.fromFirestore(doc).toDomain()).toList());
  }

  @override
  Future<void> updateOrderStatus(String id, String status) async {
    await _orders.doc(id).update({'status': status});
  }
}
