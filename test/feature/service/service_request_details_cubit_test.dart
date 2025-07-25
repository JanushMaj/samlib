import 'package:test/test.dart';

import 'package:kabast/feature/service/cubit/service_request_details_cubit.dart';
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
  final request = ServiceRequestElement(
    id: 'r1',
    createdBy: 'u1',
    createdAt: DateTime(2024, 1, 1),
    location: 'loc',
    description: 'desc',
    orderNumber: 'o1',
    urgency: ServiceUrgency.normal,
    estimatedDuration: const Duration(minutes: 60),
    requiredPeopleCount: 1,
  );

  test('saves edited request', () async {
    final service = _FakeService();
    final repo = ServiceRequestRepository(service);
    final cubit = ServiceRequestDetailsCubit(repo, request);

    cubit.setDurationMinutes(90);
    cubit.setPeopleCount(2);

    await cubit.save();

    expect(service.saved, isNotNull);
    expect(service.saved!.estimatedDuration, const Duration(minutes: 90));
    expect(service.saved!.requiredPeopleCount, 2);
  });

  test('validation prevents save', () async {
    final service = _FakeService();
    final repo = ServiceRequestRepository(service);
    final cubit = ServiceRequestDetailsCubit(repo, request);

    cubit.setDurationMinutes(0);
    cubit.setPeopleCount(0);

    await cubit.save();

    expect(service.saved, isNull);
    expect(cubit.state.errorMsg, isNotNull);
  });
}
