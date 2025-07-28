import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:kabast/feature/service/screens/service_request_approval_screen.dart';
import 'package:kabast/data/repositories/grafik_element_repository.dart';
import 'package:kabast/data/repositories/task_assignment_repository.dart';
import 'package:kabast/data/repositories/service_request_repository.dart';
import 'package:kabast/data/repositories/employee_repository.dart';
import 'package:kabast/domain/services/i_grafik_element_service.dart';
import 'package:kabast/domain/services/i_task_assignment_service.dart';
import 'package:kabast/domain/services/i_service_request_service.dart';
import 'package:kabast/domain/services/i_employee_service.dart';
import 'package:kabast/domain/models/grafik/impl/service_request_element.dart';
import 'package:kabast/domain/models/grafik/task_assignment.dart';
import 'package:kabast/domain/models/employee.dart';
import 'package:kabast/feature/auth/auth_cubit.dart';
import 'package:kabast/feature/auth/screen/no_access_screen.dart';
import 'package:kabast/domain/services/i_auth_service.dart';
import 'package:kabast/domain/models/app_user.dart';

class _DummyGrafikService implements IGrafikElementService {
  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class FakeGrafikElementRepository extends GrafikElementRepository {
  FakeGrafikElementRepository() : super(_DummyGrafikService());
  GrafikElement? saved;
  @override
  Future<void> saveGrafikElement(GrafikElement element) async {
    saved = element;
  }

  @override
  String generateNewTaskId() => 't1';
}

class _DummyAssignmentService implements ITaskAssignmentService {
  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class FakeTaskAssignmentRepository extends TaskAssignmentRepository {
  FakeTaskAssignmentRepository() : super(_DummyAssignmentService());
  final List<TaskAssignment> saved = [];
  @override
  Future<void> saveTaskAssignment(TaskAssignment assignment) async {
    saved.add(assignment);
  }
}

class _FakeServiceRequestService implements IServiceRequestService {
  final Stream<List<ServiceRequestElement>> _stream;
  String? deleted;
  _FakeServiceRequestService(this._stream);
  @override
  Stream<List<ServiceRequestElement>> watchServiceRequests() => _stream;
  @override
  Future<void> upsertServiceRequest(ServiceRequestElement request) async {}
  @override
  Future<void> deleteServiceRequest(String id) async {
    deleted = id;
  }
}

class FakeServiceRequestRepository extends ServiceRequestRepository {
  final _FakeServiceRequestService impl;
  FakeServiceRequestRepository(Stream<List<ServiceRequestElement>> stream)
      : impl = _FakeServiceRequestService(stream),
        super(_FakeServiceRequestService(stream));
  @override
  Stream<List<ServiceRequestElement>> watchServiceRequests() => impl.watchServiceRequests();
  @override
  Future<void> deleteServiceRequest(String id) => impl.deleteServiceRequest(id);
}

class _DummyEmployeeService implements IEmployeeService {
  @override
  Stream<List<Employee>> getEmployeesStream() =>
      Stream.value([Employee(uid: 'e1', role: 'r', fullName: 'Foo Bar')]);
  @override
  Future<void> upsertEmployee(Employee employee) async {}
}

class FakeEmployeeRepository extends EmployeeRepository {
  FakeEmployeeRepository() : super(_DummyEmployeeService());
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
  testWidgets('approves request and saves assignments', (tester) async {
    final req = ServiceRequestElement(
      id: 'r1',
      createdBy: 'u1',
      createdAt: DateTime(2024, 1, 1),
      location: 'loc',
      description: 'desc',
      orderNumber: 'o1',
      estimatedDuration: const Duration(minutes: 60),
      requiredPeopleCount: 1,
    );

    final reqRepo = FakeServiceRequestRepository(Stream.value([req]));
    final grafikRepo = FakeGrafikElementRepository();
    final assignRepo = FakeTaskAssignmentRepository();
    final empRepo = FakeEmployeeRepository();

    GetIt.I.registerSingleton<ServiceRequestRepository>(reqRepo);
    GetIt.I.registerSingleton<GrafikElementRepository>(grafikRepo);
    GetIt.I.registerSingleton<TaskAssignmentRepository>(assignRepo);
    GetIt.I.registerSingleton<EmployeeRepository>(empRepo);

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
        child: const MaterialApp(home: ServiceRequestApprovalScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('o1'), findsOneWidget);

    await tester.tap(find.text('Foo'));
    await tester.pump();
    await tester.tap(find.text('Zatwierdź'));
    await tester.pumpAndSettle();

    expect(grafikRepo.saved, isNotNull);
    expect(assignRepo.saved.length, 1);
    expect(reqRepo.impl.deleted, 'r1');

    GetIt.I.reset();
    await authCubit.close();
  });

  testWidgets('denies access without permission', (tester) async {
    final reqRepo = FakeServiceRequestRepository(const Stream.empty());
    final grafikRepo = FakeGrafikElementRepository();
    final assignRepo = FakeTaskAssignmentRepository();
    final empRepo = FakeEmployeeRepository();

    GetIt.I.registerSingleton<ServiceRequestRepository>(reqRepo);
    GetIt.I.registerSingleton<GrafikElementRepository>(grafikRepo);
    GetIt.I.registerSingleton<TaskAssignmentRepository>(assignRepo);
    GetIt.I.registerSingleton<EmployeeRepository>(empRepo);

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
        child: const MaterialApp(home: ServiceRequestApprovalScreen()),
      ),
    );
    await tester.pump();

    expect(find.byType(NoAccessScreen), findsOneWidget);

    GetIt.I.reset();
    await authCubit.close();
  });
}
