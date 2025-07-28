import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kabast/feature/service/screens/service_request_form_screen.dart';
import 'package:kabast/feature/auth/auth_cubit.dart';
import 'package:kabast/feature/auth/screen/no_access_screen.dart';
import 'package:kabast/data/repositories/service_request_repository.dart';
import 'package:kabast/domain/services/i_service_request_service.dart';
import 'package:kabast/domain/services/i_auth_service.dart';
import 'package:kabast/domain/models/app_user.dart';
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

class FakeAuthService implements IAuthService {
  final AppUser? user;
  FakeAuthService(this.user);

  @override
  Stream<AppUser?> authStateChanges() => Stream.value(user);

  @override
  Future<void> signUp(String email, String password) async {}

  @override
  Future<void> signIn(String email, String password) async {}

  @override
  Future<void> signOut() async {}
}

void main() {
  testWidgets('fill form and save', (tester) async {
    final service = _FakeService();
    final repo = ServiceRequestRepository(service);
    GetIt.I.registerSingleton<ServiceRequestRepository>(repo);

    final user = AppUser(
      id: 'u1',
      email: 'e',
      fullName: 'f',
      employeeId: '',
      role: UserRole.kierownik,
      permissionsOverride: const {},
    );
    final authCubit = AuthCubit(FakeAuthService(user));

    await tester.pumpWidget(
      BlocProvider<AuthCubit>.value(
        value: authCubit,
        child: const MaterialApp(home: ServiceRequestFormScreen()),
      ),
    );
    await tester.pump();

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
    await authCubit.close();
  });

  testWidgets('denies access when permission missing', (tester) async {
    final service = _FakeService();
    final repo = ServiceRequestRepository(service);
    GetIt.I.registerSingleton<ServiceRequestRepository>(repo);

    final user = AppUser(
      id: 'u2',
      email: 'e2',
      fullName: 'f2',
      employeeId: '',
      role: UserRole.user,
      permissionsOverride: const {},
    );
    final authCubit = AuthCubit(FakeAuthService(user));

    await tester.pumpWidget(
      BlocProvider<AuthCubit>.value(
        value: authCubit,
        child: const MaterialApp(home: ServiceRequestFormScreen()),
      ),
    );
    await tester.pump();

    expect(find.byType(NoAccessScreen), findsOneWidget);

    GetIt.I.reset();
    await authCubit.close();
  });
}
