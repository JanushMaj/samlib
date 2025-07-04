import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:kabast/domain/models/grafik/impl/time_issue_element.dart';
import 'package:kabast/data/grafik_resolver.dart';
import 'package:kabast/data/repositories/employee_repository.dart';
import 'package:kabast/data/repositories/grafik_element_repository.dart';
import 'package:kabast/data/repositories/vehicle_repository.dart';
import 'package:kabast/domain/models/employee.dart';
import 'package:kabast/domain/models/grafik/grafik_element.dart';
import 'package:kabast/domain/models/grafik/impl/delivery_planning_element.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/domain/models/grafik/impl/task_planning_element.dart';
import 'package:kabast/domain/models/vehicle.dart';
import 'grafik_mapping_utils.dart';
import 'grafik_state.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class GrafikCubit extends Cubit<GrafikState> {
  final GrafikElementRepository _grafikRepo;
  final VehicleRepository _vehicleRepo;
  final EmployeeRepository _employeeRepo;
  late final GrafikResolver _grafikResolver;

  late StreamSubscription<Map<String, dynamic>> _mappingSub;
  StreamSubscription<List<Vehicle>>? _vehicleSub;
  late StreamSubscription _weekDataSub;
  Timer? _updateTimer;

  GrafikCubit(
      this._grafikRepo,
      this._vehicleRepo,
      this._employeeRepo,
      ) : super(GrafikState.initial()) {
    _grafikResolver = GrafikResolver(_grafikRepo);
    _resolveInitialDayAndLoad();
    _subscribeVehicles();
    _scheduleUpdateAtGrafikChangeTime();
  }

  void _resolveInitialDayAndLoad() async {
    final resolved = await _resolveGrafikLogicBasedOnTime(DateTime.now());
    changeSelectedDay(resolved);
    _loadWeekForSelectedDay();
  }

  Future<DateTime> _resolveGrafikLogicBasedOnTime(DateTime now) async {
    final grafikChangeTime = DateTime(now.year, now.month, now.day, 14, 45);
    final baseDay = now.isBefore(grafikChangeTime)
        ? DateTime(now.year, now.month, now.day)
        : DateTime(now.year, now.month, now.day).add(const Duration(days: 1));

    return await _grafikResolver.nextDayWithGrafik(baseDay);
  }

  void _scheduleUpdateAtGrafikChangeTime() {
    final now = DateTime.now();
    DateTime nextUpdate = DateTime(now.year, now.month, now.day, 14, 45);
    if (now.isAfter(nextUpdate)) {
      nextUpdate = nextUpdate.add(const Duration(days: 1));
    }

    final durationUntilUpdate = nextUpdate.difference(now);
    _updateTimer?.cancel();
    _updateTimer = Timer(durationUntilUpdate, () async {
      final resolvedDay = await _resolveGrafikLogicBasedOnTime(DateTime.now());
      changeSelectedDay(resolvedDay);
      _scheduleUpdateAtGrafikChangeTime();
    });
  }

  void changeSelectedDay(DateTime newDay) {
    final monday = _calculateMonday(newDay);
    if (!isClosed) {
      emit(state.copyWith(
        selectedDay: newDay,
        selectedDayInWeekView: monday,
      ));
    }
    _subscribeMapping(newDay);
    _loadWeekForSelectedDay();
  }

  DateTime _calculateMonday(DateTime day) {
    final monday = day.subtract(Duration(days: day.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);
  }

  void _subscribeVehicles() {
    _vehicleSub = _vehicleRepo.getVehicles().listen(
          (vehicles) {
        if (!isClosed) {
          emit(state.copyWith(vehicles: vehicles));
        }
      },
      onError: (error) {
        if (!isClosed) {
          emit(state.copyWith(error: error.toString()));
        }
      },
    );
  }

  void _subscribeMapping(DateTime day) {
    try {
      _mappingSub.cancel();
    } catch (_) {}

    final start = DateTime(day.year, day.month, day.day);
    final end = DateTime(day.year, day.month, day.day, 23, 59, 59, 999);

    _mappingSub = Rx.combineLatest2<List<GrafikElement>, List<Employee>, Map<String, dynamic>>(
      _grafikRepo.getElementsWithinRange(
        start: start,
        end: end,
        types: ['TaskElement', 'TimeIssueElement'],
      ),
      _employeeRepo.getEmployees(),
          (elements, employees) {
        final tasks = elements.whereType<TaskElement>().toList();
        final issues = elements.whereType<TimeIssueElement>().toList();

        final mapping = calculateTaskTimeIssueDisplayMapping(
          tasks: tasks,
          issues: issues,
          employees: employees,
        );

        final transferMapping = calculateTaskTransferDisplayMapping(
          tasks: tasks,
          employees: employees,
        );

        return {
          'tasks': tasks,
          'issues': issues,
          'employees': employees,
          'mapping': mapping,
          'transferMapping': transferMapping,
        };
      },
    ).listen((combinedData) {
      if (!isClosed) {
        emit(state.copyWith(
          tasks: combinedData['tasks'] as List<TaskElement>,
          issues: combinedData['issues'] as List<TimeIssueElement>,
          employees: combinedData['employees'] as List<Employee>,
          taskTimeIssueDisplayMapping: combinedData['mapping'] as Map<String, List<String>>,
          taskTransferDisplayMapping: combinedData['transferMapping'] as Map<String, List<String>>,
        ));
      }
    });
  }

  void _loadWeekForSelectedDay() {
    final monday = state.selectedDayInWeekView;
    final friday = monday.add(const Duration(days: 4, hours: 23, minutes: 59, seconds: 59, milliseconds: 999));

    final grafikStream = _grafikRepo.getElementsWithinRange(
      start: monday,
      end: friday,
      types: [
        'TaskElement',
        'TimeIssueElement',
        'TaskPlanningElement',
        'DeliveryPlanningElement',
      ],
    );

    final employeeStream = _employeeRepo.getEmployees();

    _weekDataSub = Rx.combineLatest2<List<GrafikElement>, List<Employee>, Map<String, dynamic>>(
      grafikStream,
      employeeStream,
          (elements, employees) {
        final taskElements = elements.whereType<TaskElement>().toList();
        final timeIssues = elements.whereType<TimeIssueElement>().toList();
        final taskPlannings = elements.whereType<TaskPlanningElement>().toList();
        final deliveryPlannings = elements.whereType<DeliveryPlanningElement>().toList();

        return {
          'taskElements': taskElements,
          'timeIssues': timeIssues,
          'taskPlannings': taskPlannings,
          'deliveryPlanningElements': deliveryPlannings,
          'employees': employees,
        };
      },
    ).listen((data) {
      final updatedWeek = state.weekData.copyWith(
        taskElements: data['taskElements'] as List<TaskElement>,
        timeIssues: data['timeIssues'] as List<TimeIssueElement>,
        taskPlannings: data['taskPlannings'] as List<TaskPlanningElement>,
        deliveryPlannings:
            data['deliveryPlanningElements'] as List<DeliveryPlanningElement>,
      );
      emit(state.copyWith(
        weekData: updatedWeek,
        employees: data['employees'] as List<Employee>,
      ));
    }, onError: (e) {
      emit(state.copyWith(error: e.toString()));
    });
  }

  @override
  Future<void> close() {
    _mappingSub.cancel();
    _vehicleSub?.cancel();
    _weekDataSub.cancel();
    _updateTimer?.cancel();
    return super.close();
  }
}
