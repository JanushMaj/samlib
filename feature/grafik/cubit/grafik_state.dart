import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/domain/models/grafik/impl/time_issue_element.dart';
import 'package:kabast/domain/models/grafik/impl/supply_run_element.dart';
import 'package:kabast/domain/models/grafik/impl/transport_plan.dart';
import 'package:kabast/domain/models/vehicle.dart';
import 'package:kabast/domain/models/employee.dart';
import 'package:kabast/domain/models/grafik/task_assignment.dart';
import 'states/week_grafik_data.dart';

class GrafikState {
  final List<TaskElement> tasks;
  final List<TimeIssueElement> issues;
  final List<SupplyRunElement> supplyRuns;
  final List<TransportPlan> transportPlans;
  final List<TaskAssignment> assignments;
  final Map<String, List<String>> taskTimeIssueDisplayMapping;
  final Map<String, List<String>> taskTransferDisplayMapping;
  final List<Vehicle> vehicles;
  final List<Employee> employees;
  final String? error;

  final WeekGrafikData weekData;

  GrafikState({
    required this.tasks,
    required this.issues,
    required this.supplyRuns,
    required this.transportPlans,
    required this.taskTimeIssueDisplayMapping,
    required this.taskTransferDisplayMapping,
    required this.assignments,
    required this.vehicles,
    required this.employees,
    this.error,
    required this.weekData,
  });

  factory GrafikState.initial() {
    return GrafikState(
      tasks: [],
      issues: [],
      supplyRuns: [],
      transportPlans: [],
      taskTimeIssueDisplayMapping: {},
      taskTransferDisplayMapping: {},
      assignments: [],
      vehicles: [],
      employees: [],
      error: null,
      weekData: WeekGrafikData.initial(),
    );
  }

  GrafikState copyWith({
    List<TaskElement>? tasks,
    List<TimeIssueElement>? issues,
    List<SupplyRunElement>? supplyRuns,
    List<TransportPlan>? transportPlans,
    Map<String, List<String>>? taskTimeIssueDisplayMapping,
    Map<String, List<String>>? taskTransferDisplayMapping,
    List<TaskAssignment>? assignments,
    List<Vehicle>? vehicles,
    List<Employee>? employees,
    String? error,
    WeekGrafikData? weekData,
  }) {
    return GrafikState(
      tasks: tasks ?? this.tasks,
      issues: issues ?? this.issues,
      supplyRuns: supplyRuns ?? this.supplyRuns,
      transportPlans: transportPlans ?? this.transportPlans,
      taskTimeIssueDisplayMapping: taskTimeIssueDisplayMapping ?? this.taskTimeIssueDisplayMapping,
      taskTransferDisplayMapping: taskTransferDisplayMapping ?? this.taskTransferDisplayMapping,
      assignments: assignments ?? this.assignments,
      vehicles: vehicles ?? this.vehicles,
      employees: employees ?? this.employees,
      error: error ?? this.error,
      weekData: weekData ?? this.weekData,
    );
  }
}
