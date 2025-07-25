import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:kabast/domain/models/grafik/impl/time_issue_element.dart';
import '../../../data/repositories/employee_repository.dart';
import '../../../data/repositories/grafik_element_repository.dart';
import '../../../data/repositories/task_assignment_repository.dart';
import '../../../domain/services/i_vehicle_watcher_service.dart';
import '../../date/date_cubit.dart';
import '../../date/date_state.dart';
import '../../../domain/models/employee.dart';
import '../../../domain/models/grafik/grafik_element.dart';
import '../../../domain/models/grafik/impl/delivery_planning_element.dart';
import '../../../domain/models/grafik/impl/task_element.dart';
import '../../../domain/models/grafik/impl/task_planning_element.dart';
import '../../../domain/models/grafik/impl/supply_run_element.dart';
import '../../../domain/models/vehicle.dart';
import '../../../domain/models/grafik/task_assignment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'grafik_mapping_utils.dart';
import 'grafik_state.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class GrafikCubit extends Cubit<GrafikState> {
  final GrafikElementRepository _grafikRepo;
  final IVehicleWatcherService _vehicleWatcher;
  final EmployeeRepository _employeeRepo;
  final TaskAssignmentRepository _taskAssignmentRepo;
  final DateCubit _dateCubit;

  late StreamSubscription<Map<String, dynamic>> _mappingSub;
  StreamSubscription<List<Vehicle>>? _vehicleSub;
  late StreamSubscription _weekDataSub;
  late final StreamSubscription<DateState> _dateSub;

  GrafikCubit(
    this._grafikRepo,
    this._vehicleWatcher,
    this._employeeRepo,
    this._taskAssignmentRepo,
    this._dateCubit,
  ) : super(GrafikState.initial()) {
    _subscribeVehicles();
    _dateSub = _dateCubit.stream.listen((dateState) {
      _subscribeMapping(dateState.selectedDay);
      _loadWeek(dateState.selectedDayInWeekView);
    });
    _subscribeMapping(_dateCubit.state.selectedDay);
    _loadWeek(_dateCubit.state.selectedDayInWeekView);
  }

  void _subscribeVehicles() {
    _vehicleSub = _vehicleWatcher.watchVehicles().listen(
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

    _mappingSub =
        Rx.combineLatest3<
              List<GrafikElement>,
              List<Employee>,
              List<TaskAssignment>,
              Map<String, dynamic>
            >(
              _grafikRepo.getElementsWithinRange(
                start: start,
                end: end,
                types: ['TaskElement', 'TimeIssueElement', 'SupplyRunElement'],
              ),
              _employeeRepo.getEmployees(),
              _taskAssignmentRepo.getAssignmentsWithinRange(
                start: start,
                end: end,
              ),
              (elements, employees, assignments) {
                final tasks = elements.whereType<TaskElement>().toList();
                final issues = elements.whereType<TimeIssueElement>().toList();
                final supplyRuns = elements
                    .whereType<SupplyRunElement>()
                    .where(
                      (r) =>
                          r.addedByUserId ==
                          FirebaseAuth.instance.currentUser?.uid,
                    )
                    .toList();

                final mapping = calculateTaskTimeIssueDisplayMapping(
                  tasks: tasks,
                  issues: issues,
                  employees: employees,
                  assignments: assignments,
                );

                final transferMapping = calculateTaskTransferDisplayMapping(
                  tasks: tasks,
                  employees: employees,
                  assignments: assignments,
                );

                return {
                  'tasks': tasks,
                  'issues': issues,
                  'supplyRuns': supplyRuns,
                  'employees': employees,
                  'assignments': assignments,
                  'mapping': mapping,
                  'transferMapping': transferMapping,
                };
              },
            )
            .listen(
              (combinedData) {
                if (!isClosed) {
                  emit(
                    state.copyWith(
                      tasks: combinedData['tasks'] as List<TaskElement>,
                      issues: combinedData['issues'] as List<TimeIssueElement>,
                      supplyRuns:
                          combinedData['supplyRuns'] as List<SupplyRunElement>,
                      employees: combinedData['employees'] as List<Employee>,
                      taskTimeIssueDisplayMapping:
                          combinedData['mapping'] as Map<String, List<String>>,
                      taskTransferDisplayMapping:
                          combinedData['transferMapping']
                              as Map<String, List<String>>,
                      assignments:
                          combinedData['assignments'] as List<TaskAssignment>,
                    ),
                  );
                }
              },
              onError: (e) {
                log('Error in _subscribeMapping: $e');
                if (!isClosed) {
                  emit(state.copyWith(error: e.toString()));
                }
              },
            );
  }

  void _loadWeek(DateTime monday) {
    final friday = monday.add(
      const Duration(
        days: 4,
        hours: 23,
        minutes: 59,
        seconds: 59,
        milliseconds: 999,
      ),
    );

    final grafikStream = _grafikRepo.getElementsWithinRange(
      start: monday,
      end: friday,
      types: [
        'TaskElement',
        'TimeIssueElement',
        'TaskPlanningElement',
        'DeliveryPlanningElement',
        'SupplyRunElement',
      ],
    );

    final employeeStream = _employeeRepo.getEmployees();
    try {
      _weekDataSub.cancel();
    } catch (_) {}

    _weekDataSub =
        Rx.combineLatest2<
              List<GrafikElement>,
              List<Employee>,
              Map<String, dynamic>
            >(grafikStream, employeeStream, (elements, employees) {
              final taskElements = elements.whereType<TaskElement>().toList();
              final timeIssues = elements
                  .whereType<TimeIssueElement>()
                  .toList();
              final taskPlannings = elements
                  .whereType<TaskPlanningElement>()
                  .toList();
              final deliveryPlannings = elements
                  .whereType<DeliveryPlanningElement>()
                  .toList();
              final supplyRuns = elements
                  .whereType<SupplyRunElement>()
                  .where(
                    (r) =>
                        r.addedByUserId ==
                        FirebaseAuth.instance.currentUser?.uid,
                  )
                  .toList();

              return {
                'taskElements': taskElements,
                'timeIssues': timeIssues,
                'taskPlannings': taskPlannings,
                'deliveryPlanningElements': deliveryPlannings,
                'supplyRuns': supplyRuns,
                'employees': employees,
              };
            })
            .listen(
              (data) {
                final updatedWeek = state.weekData.copyWith(
                  taskElements: data['taskElements'] as List<TaskElement>,
                  timeIssues: data['timeIssues'] as List<TimeIssueElement>,
                  taskPlannings:
                      data['taskPlannings'] as List<TaskPlanningElement>,
                  deliveryPlannings:
                      data['deliveryPlanningElements']
                          as List<DeliveryPlanningElement>,
                  supplyRuns: data['supplyRuns'] as List<SupplyRunElement>,
                );
                emit(
                  state.copyWith(
                    weekData: updatedWeek,
                    employees: data['employees'] as List<Employee>,
                  ),
                );
              },
              onError: (e) {
                emit(state.copyWith(error: e.toString()));
              },
            );
  }

  Future<Duration> getTotalWorkTimeForEmployee({
    required String workerId,
    required DateTime start,
    required DateTime end,
  }) async {
    final assignments = await _taskAssignmentRepo
        .getAssignmentsWithinRange(start: start, end: end)
        .first;

    Duration total = Duration.zero;
    for (final a in assignments.where((a) => a.workerId == workerId)) {
      final s = a.startDateTime.isBefore(start) ? start : a.startDateTime;
      final f = a.endDateTime.isAfter(end) ? end : a.endDateTime;
      final diff = f.difference(s);
      if (diff.isNegative) continue;
      total += diff;
    }
    return total;
  }

  @override
  Future<void> close() {
    _mappingSub.cancel();
    _vehicleSub?.cancel();
    _weekDataSub.cancel();
    _dateSub.cancel();
    return super.close();
  }
}
