import 'package:test/test.dart';
import 'package:kabast/feature/grafik/cubit/grafik_cubit.dart';
import 'package:kabast/data/repositories/grafik_element_repository.dart';
import 'package:kabast/data/repositories/employee_repository.dart';
import 'package:kabast/data/repositories/task_assignment_repository.dart';
import 'package:kabast/domain/services/i_grafik_element_service.dart';
import 'package:kabast/domain/services/i_employee_service.dart';
import 'package:kabast/domain/services/i_task_assignment_service.dart';
import 'package:kabast/domain/services/i_vehicle_watcher_service.dart';
import 'package:kabast/domain/services/i_grafik_resolver.dart';
import 'package:kabast/feature/date/date_cubit.dart';
import 'package:kabast/feature/date/date_state.dart';
import 'package:kabast/domain/models/grafik/grafik_element.dart';
import 'package:kabast/domain/models/grafik/impl/service_request_element.dart';
import 'package:kabast/domain/models/grafik/impl/service_request_to_task_extension.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/domain/models/grafik/task_assignment.dart';
import 'package:kabast/domain/models/employee.dart';
import 'package:kabast/domain/models/vehicle.dart';

class _DummyGrafikService implements IGrafikElementService {
  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class FakeGrafikElementRepository extends GrafikElementRepository {
  final Stream<List<GrafikElement>> _stream;
  FakeGrafikElementRepository(this._stream) : super(_DummyGrafikService());

  @override
  Stream<List<GrafikElement>> getElementsWithinRange({
    required DateTime start,
    required DateTime end,
    List<String>? types,
  }) => _stream;
}

class FakeVehicleWatcher implements IVehicleWatcherService {
  final Stream<List<Vehicle>> _stream;
  FakeVehicleWatcher([Stream<List<Vehicle>>? stream])
      : _stream = stream ?? const Stream.empty();

  @override
  Stream<List<Vehicle>> watchVehicles() => _stream;
}

class _DummyEmployeeService implements IEmployeeService {
  @override
  Stream<List<Employee>> getEmployeesStream() => const Stream.empty();
  @override
  Future<void> upsertEmployee(Employee employee) async {}
}

class FakeEmployeeRepository extends EmployeeRepository {
  FakeEmployeeRepository() : super(_DummyEmployeeService());

  @override
  Stream<List<Employee>> getEmployees() => const Stream.empty();
}

class _DummyAssignmentService implements ITaskAssignmentService {
  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class FakeTaskAssignmentRepository extends TaskAssignmentRepository {
  FakeTaskAssignmentRepository() : super(_DummyAssignmentService());

  @override
  Stream<List<TaskAssignment>> getAssignmentsWithinRange({
    required DateTime start,
    required DateTime end,
  }) => const Stream.empty();
}

class FakeGrafikResolver implements IGrafikResolver {
  final DateTime date;
  FakeGrafikResolver(this.date);
  @override
  Future<DateTime> nextDayWithGrafik(DateTime from) async => date;
}

void main() {
  test('service request converted to task appears in cubit state', () async {
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
    final task = request.toTaskElement().copyWithId('t1');

    final grafikRepo = FakeGrafikElementRepository(Stream.value([task]));
    final vehicleWatcher = FakeVehicleWatcher();
    final employeeRepo = FakeEmployeeRepository();
    final assignmentRepo = FakeTaskAssignmentRepository();
    final dateCubit = DateCubit(FakeGrafikResolver(task.startDateTime));

    final cubit = GrafikCubit(
      grafikRepo,
      vehicleWatcher,
      employeeRepo,
      assignmentRepo,
      dateCubit,
    );

    await Future.delayed(Duration.zero);

    expect(cubit.state.tasks.any((t) => t.id == task.id), isTrue);

    await cubit.close();
    await dateCubit.close();
  });
}

