import '../models/grafik/impl/service_request_element.dart';

abstract class IServiceRequestService {
  Stream<List<ServiceRequestElement>> watchServiceRequests();
  Future<void> upsertServiceRequest(ServiceRequestElement request);
  Future<void> deleteServiceRequest(String id);
}
