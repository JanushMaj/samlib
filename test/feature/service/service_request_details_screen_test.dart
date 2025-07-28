import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kabast/feature/service/screens/service_request_details_screen.dart';
import 'package:kabast/feature/auth/auth_cubit.dart';
import 'package:kabast/feature/auth/screen/no_access_screen.dart';
import 'package:kabast/data/repositories/service_request_repository.dart';
import 'package:kabast/domain/services/i_service_request_service.dart';
import 'package:kabast/domain/services/i_auth_service.dart';
import 'package:kabast/domain/models/app_user.dart';
import 'package:kabast/domain/models/grafik/impl/service_request_element.dart';
import 'package:kabast/domain/models/grafik/enums.dart';

class _FakeService implements IServiceRequestService {
  @override
  Stream<List<ServiceRequestElement>> watchServiceRequests() => const Stream.empty();
  @override
  Future<void> upsertServiceRequest(ServiceRequestElement request) async {}
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
  testWidgets('creator can view request', (tester) async {
    final repo = ServiceRequestRepository(_FakeService());
    GetIt.I.registerSingleton<ServiceRequestRepository>(repo);

    final request = ServiceRequestElement(
      id: 'r1',
      createdBy: 'u1',
      createdAt: DateTime(2024, 1, 1),
      location: 'loc',
      description: 'desc',
      orderNumber: 'o1',
      estimatedDuration: const Duration(minutes: 60),
      requiredPeopleCount: 1,
    );

    final user = AppUser(
      id: 'u1',
      email: 'e',
      fullName: 'f',
      employeeId: '',
      role: UserRole.user,
      permissionsOverride: const {},
    );
    final authCubit = AuthCubit(FakeAuthService(user));

    await tester.pumpWidget(
      BlocProvider<AuthCubit>.value(
        value: authCubit,
        child: MaterialApp(
          home: ServiceRequestDetailsScreen(request: request),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(NoAccessScreen), findsNothing);
    expect(find.text('desc'), findsOneWidget);

    GetIt.I.reset();
    await authCubit.close();
  });
}
