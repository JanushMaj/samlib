import '../../domain/models/grafik/impl/service_request_element.dart';
import '../../domain/services/i_service_request_service.dart';

class ServiceRequestRepository {
  final IServiceRequestService _service;

  ServiceRequestRepository(this._service);

  Stream<List<ServiceRequestElement>> watchServiceRequests() {
    return _service.watchServiceRequests();
  }

  Future<void> saveServiceRequest(ServiceRequestElement request) {
    return _service.upsertServiceRequest(request);
  }

  Future<void> deleteServiceRequest(String id) {
    return _service.deleteServiceRequest(id);
  }
}
