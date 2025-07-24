import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:kabast/feature/supplies/supply_run_approval_screen.dart';
import 'package:kabast/data/repositories/grafik_element_repository.dart';
import 'package:kabast/domain/models/grafik/grafik_element.dart';
import 'package:kabast/domain/models/grafik/impl/supply_run_element.dart';
import 'package:kabast/domain/services/i_grafik_element_service.dart';
import 'package:kabast/data/repositories/app_user_repository.dart';
import 'package:kabast/domain/models/app_user.dart';
import 'package:kabast/domain/services/i_app_user_service.dart';
import 'package:kabast/domain/services/i_supply_repository.dart';
import 'package:kabast/domain/models/supply_item.dart';
import 'package:kabast/domain/models/supply_order.dart';

class _DummyService implements IGrafikElementService {
  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class FakeGrafikElementRepository extends GrafikElementRepository {
  final Stream<List<GrafikElement>> _stream;
  FakeGrafikElementRepository(this._stream) : super(_DummyService());

  @override
  Stream<List<GrafikElement>> getElementsWithinRange({
    required DateTime start,
    required DateTime end,
    List<String>? types,
  }) {
    return _stream;
  }
}

class _DummyUserService implements IAppUserService {
  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class FakeAppUserRepository extends AppUserRepository {
  FakeAppUserRepository() : super(_DummyUserService());

  @override
  Future<AppUser?> getUser(String uid) async => AppUser(
        id: uid,
        email: '',
        fullName: 'User $uid',
        employeeId: '',
        role: UserRole.user,
        permissionsOverride: const {},
      );
}

class FakeSupplyRepository implements ISupplyRepository {
  @override
  Stream<List<SupplyItem>> watchItems() => const Stream.empty();
  @override
  Future<void> saveItem(SupplyItem item) async {}
  @override
  Future<void> placeOrder(SupplyOrder order) async {}
  @override
  Stream<List<SupplyOrder>> watchOrders() => const Stream.empty();
  @override
  Future<void> updateOrderStatus(String id, String status) async {}
}

void main() {
  testWidgets('upcoming runs are hidden', (tester) async {
    final now = DateTime.now();
    final pastRun = SupplyRunElement(
      id: '1',
      startDateTime: now.subtract(const Duration(hours: 2)),
      endDateTime: now.subtract(const Duration(hours: 1)),
      additionalInfo: '',
      supplyOrderIds: const [],
      routeDescription: 'past',
      addedByUserId: 'u1',
      addedTimestamp: now,
      closed: false,
    );
    final futureRun = SupplyRunElement(
      id: '2',
      startDateTime: now.add(const Duration(hours: 1)),
      endDateTime: now.add(const Duration(hours: 2)),
      additionalInfo: '',
      supplyOrderIds: const [],
      routeDescription: 'future',
      addedByUserId: 'u1',
      addedTimestamp: now,
      closed: false,
    );

    final repo = FakeGrafikElementRepository(Stream.value([pastRun, futureRun]));
    final userRepo = FakeAppUserRepository();

    GetIt.I.registerSingleton<GrafikElementRepository>(repo);
    GetIt.I.registerSingleton<AppUserRepository>(userRepo);
    GetIt.I.registerSingleton<ISupplyRepository>(FakeSupplyRepository());

    await tester.pumpWidget(const MaterialApp(home: SupplyRunApprovalScreen()));
    await tester.pump();

    expect(find.text('past'), findsOneWidget);
    expect(find.text('future'), findsNothing);

    GetIt.I.reset();
  });
}
