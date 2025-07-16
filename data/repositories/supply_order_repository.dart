import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/supply_order.dart';
import '../dto/supply_order_dto.dart';

class SupplyOrderRepository {
  final FirebaseFirestore _firestore;

  SupplyOrderRepository(this._firestore);

  CollectionReference get _orders => _firestore.collection('supply_orders');

  Stream<List<SupplyOrder>> watchPendingOrders() {
    return _orders
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((query) => query.docs
            .map((doc) => SupplyOrderDto.fromFirestore(doc).toDomain())
            .toList());
  }

  Future<void> markAsAssigned(List<String> ids) async {
    final batch = _firestore.batch();
    for (final id in ids) {
      final ref = _orders.doc(id);
      batch.update(ref, {'status': 'assigned'});
    }
    await batch.commit();
  }
}
