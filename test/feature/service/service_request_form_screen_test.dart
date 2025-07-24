import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:kabast/feature/service/screens/service_request_form_screen.dart';
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
  testWidgets('fill form and save', (tester) async {
    final service = _FakeService();
    final repo = ServiceRequestRepository(service);
    GetIt.I.registerSingleton<ServiceRequestRepository>(repo);

    await tester.pumpWidget(const MaterialApp(home: ServiceRequestFormScreen()));

    await tester.enterText(find.bySemanticsLabel('Lokalizacja'), 'loc');
    await tester.enterText(find.bySemanticsLabel('Nr zlecenia'), 'o1');
    await tester.enterText(find.bySemanticsLabel('Opis'), 'desc');
    await tester.tap(find.text('Pilne'));
    await tester.pump();
    await tester.tap(find.text('Zapisz'));
    await tester.pumpAndSettle();

    expect(service.saved, isNotNull);
    expect(service.saved!.description, 'desc');

    GetIt.I.reset();
  });
}
