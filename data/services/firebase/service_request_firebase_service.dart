import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/grafik/impl/service_request_element.dart';
import '../../dto/grafik/service_request_element_dto.dart';
import '../../../domain/services/i_service_request_service.dart';

class ServiceRequestFirebaseService implements IServiceRequestService {
  final FirebaseFirestore _firestore;

  ServiceRequestFirebaseService(this._firestore);

  CollectionReference get _col => _firestore.collection('service_requests');

  @override
  Stream<List<ServiceRequestElement>> watchServiceRequests() {
    return _col.snapshots().map((query) => query.docs
        .map((doc) =>
            ServiceRequestElementDto.fromFirestore(doc).toDomain())
        .toList());
  }

  @override
  Future<void> upsertServiceRequest(ServiceRequestElement request) async {
    final dto = ServiceRequestElementDto.fromDomain(request);
    if (request.id.isEmpty) {
      final ref = await _col.add(dto.toJson());
      await ref.update({'id': ref.id});
    } else {
      await _col.doc(request.id).set(dto.toJson());
    }
  }

  @override
  Future<void> deleteServiceRequest(String id) => _col.doc(id).delete();
}
