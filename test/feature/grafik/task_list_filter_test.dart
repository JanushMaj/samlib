import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kabast/feature/grafik/widget/task/task_list.dart';
import 'package:kabast/feature/grafik/form/standard_task_row.dart';
import 'package:kabast/feature/grafik/cubit/grafik_cubit.dart';
import 'package:kabast/feature/auth/auth_cubit.dart';
import 'package:kabast/domain/services/i_auth_service.dart';
import 'package:kabast/domain/models/app_user.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/domain/models/grafik/impl/task_template.dart';
import 'package:kabast/domain/models/grafik/task_assignment.dart';
import 'package:kabast/domain/models/grafik/enums.dart';
import 'package:kabast/shared/responsive/responsive_layout.dart';

class _FakeGrafikCubit extends Cubit<GrafikState> {
  _FakeGrafikCubit(GrafikState state) : super(state);
}

class _FakeAuthService implements IAuthService {
  final AppUser? user;
  _FakeAuthService(this.user);

  @override
  Stream<AppUser?> authStateChanges() => Stream.value(user);

  @override
  Future<void> signUp(String email, String password) async {}

  @override
  Future<void> signIn(String email, String password) async {}

  @override
  Future<void> signOut() async {}
}

class _TestAuthCubit extends AuthCubit {
  _TestAuthCubit(AppUser? user) : super(_FakeAuthService(user));
}

void main() {
  testWidgets('standard tasks are visible even when not assigned', (tester) async {
    final standardTask = TaskElement(
      id: 'std',
      startDateTime: DateTime(2023, 1, 1, 8),
      endDateTime: DateTime(2023, 1, 1, 9),
      additionalInfo: 'std',
      orderId: kStandardOrderId,
      status: GrafikStatus.Realizacja,
      taskType: GrafikTaskType.Inne,
      carIds: const [],
      addedByUserId: 'u1',
      addedTimestamp: DateTime(2023, 1, 1),
      closed: false,
    );

    final otherTask = TaskElement(
      id: 'other',
      startDateTime: DateTime(2023, 1, 1, 10),
      endDateTime: DateTime(2023, 1, 1, 11),
      additionalInfo: 'other',
      orderId: '123',
      status: GrafikStatus.Realizacja,
      taskType: GrafikTaskType.Inne,
      carIds: const [],
      addedByUserId: 'u1',
      addedTimestamp: DateTime(2023, 1, 1),
      closed: false,
    );

    final assignments = [
      TaskAssignment(
        taskId: otherTask.id,
        workerId: 'e1',
        startDateTime: otherTask.startDateTime,
        endDateTime: otherTask.endDateTime,
      ),
    ];

    final state = GrafikState.initial().copyWith(
      tasks: [standardTask, otherTask],
      assignments: assignments,
    );

    final grafikCubit = _FakeGrafikCubit(state);
    final authCubit = _TestAuthCubit(
      AppUser(
        id: 'u1',
        email: 'a@a.com',
        fullName: 'User A',
        employeeId: 'e1',
        role: UserRole.user,
        permissionsOverride: const {},
      ),
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<GrafikCubit>.value(value: grafikCubit),
          BlocProvider<AuthCubit>.value(value: authCubit),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: TaskList(
              date: DateTime(2023, 1, 1),
              breakpoint: Breakpoint.small,
              showAll: false,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(StandardTaskRow), findsOneWidget);
  });
}
