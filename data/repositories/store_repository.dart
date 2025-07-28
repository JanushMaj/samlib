import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/store.dart';
import '../dto/store_dto.dart';

class StoreRepository {
  final FirebaseFirestore _firestore;

  StoreRepository(this._firestore);

  CollectionReference get _stores => _firestore.collection('stores');

  Stream<List<Store>> watchStores() {
    return _stores.snapshots().map(
          (query) =>
              query.docs.map((doc) => StoreDto.fromFirestore(doc).toDomain()).toList(),
        );
  }

  Future<void> saveStore(Store store) async {
    final dto = StoreDto.fromDomain(store);
    if (store.id.isEmpty) {
      final ref = await _stores.add(dto.toJson());
      await ref.update({'id': ref.id});
    } else {
      await _stores.doc(store.id).set(dto.toJson());
    }
  }
}
