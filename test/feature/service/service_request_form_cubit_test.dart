import 'package:test/test.dart';

import 'package:kabast/feature/service/cubit/service_request_form_cubit.dart';
import 'package:kabast/data/repositories/service_request_repository.dart';
import 'package:kabast/domain/services/i_service_request_service.dart';
import 'package:kabast/domain/models/grafik/impl/service_request_element.dart';
import 'package:kabast/domain/models/grafik/enums.dart';

class _FakeService implements IServiceRequestService {
  ServiceRequestElement? saved;
  @override
  Stream<List<ServiceRequestElement>> watchServiceRequests() => const Stream.empty();
  @override
  Future<void> upsertServiceRequest(ServiceRequestElement request) async {
    saved = request;
  }
  @override
  Future<void> deleteServiceRequest(String id) async {}
}

void main() {
  test('saves request when data valid', () async {
    final service = _FakeService();
    final repo = ServiceRequestRepository(service);
    final cubit = ServiceRequestFormCubit(repo);

    cubit.setLocation('loc');
    cubit.setDescription('desc');
    cubit.setOrderNumber('o1');
    cubit.setUrgency(ServiceUrgency.pilne);

    await cubit.save('u1');

    expect(service.saved, isNotNull);
    expect(service.saved!.location, 'loc');
    expect(service.saved!.description, 'desc');
    expect(service.saved!.orderNumber, 'o1');
    expect(service.saved!.urgency, ServiceUrgency.pilne);
  });

  test('validation prevents save', () async {
    final service = _FakeService();
    final repo = ServiceRequestRepository(service);
    final cubit = ServiceRequestFormCubit(repo);

    await cubit.save('u1');

    expect(service.saved, isNull);
    expect(cubit.state.errorMsg, isNotNull);
  });
}
