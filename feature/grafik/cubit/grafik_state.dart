import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/domain/models/grafik/impl/time_issue_element.dart';
import 'package:kabast/domain/models/grafik/impl/task_planning_element.dart';
import 'package:kabast/domain/models/grafik/impl/delivery_planning_element.dart';
import 'package:kabast/domain/models/vehicle.dart';
import 'package:kabast/domain/models/employee.dart';

class GrafikState {
  final List<TaskElement> tasks;
  final List<TimeIssueElement> issues;
  final Map<String, List<String>> taskTimeIssueDisplayMapping;
  final Map<String, List<String>> taskTransferDisplayMapping; // <<< NOWE POLE
  final List<Vehicle> vehicles;
  final List<Employee> employees;
  final DateTime selectedDay;
  final DateTime selectedDayInWeekView; // nowa właściwość
  final String? error;

  final List<TaskElement> weekTaskElements;
  final List<TimeIssueElement> weekTimeIssueElements;
  final List<TaskPlanningElement> weekTaskPlanningElements;
  final List<DeliveryPlanningElement> weekDeliveryPlanningElements;

  GrafikState({
    required this.tasks,
    required this.issues,
    required this.taskTimeIssueDisplayMapping,
    required this.taskTransferDisplayMapping, // <<< NOWE POLE
    required this.vehicles,
    required this.employees,
    required this.selectedDay,
    required this.selectedDayInWeekView,
    this.error,
    required this.weekTaskElements,
    required this.weekTimeIssueElements,
    required this.weekTaskPlanningElements,
    required this.weekDeliveryPlanningElements,
  });

  factory GrafikState.initial() {
    final now = DateTime.now();
    // Obliczamy poniedziałek bieżącego tygodnia
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return GrafikState(
      tasks: [],
      issues: [],
      taskTimeIssueDisplayMapping: {},
      taskTransferDisplayMapping: {}, // <<< INICJALIZACJA
      vehicles: [],
      employees: [],
      selectedDay: now,
      selectedDayInWeekView: monday,
      error: null,
      weekTaskElements: [],
      weekTimeIssueElements: [],
      weekTaskPlanningElements: [],
      weekDeliveryPlanningElements: [],
    );
  }

  GrafikState copyWith({
    List<TaskElement>? tasks,
    List<TimeIssueElement>? issues,
    Map<String, List<String>>? taskTimeIssueDisplayMapping,
    Map<String, List<String>>? taskTransferDisplayMapping, // <<< NOWY PARAMETR
    List<Vehicle>? vehicles,
    List<Employee>? employees,
    DateTime? selectedDay,
    DateTime? selectedDayInWeekView,
    String? error,
    List<TaskElement>? weekTaskElements,
    List<TimeIssueElement>? weekTaskIssueElements,
    List<TaskPlanningElement>? weekTaskPlanningElements,
    List<DeliveryPlanningElement>? weekDeliveryPlanningElements,
  }) {
    return GrafikState(
      tasks: tasks ?? this.tasks,
      issues: issues ?? this.issues,
      taskTimeIssueDisplayMapping: taskTimeIssueDisplayMapping ?? this.taskTimeIssueDisplayMapping,
      taskTransferDisplayMapping: taskTransferDisplayMapping ?? this.taskTransferDisplayMapping, // <<< NOWE POLE
      vehicles: vehicles ?? this.vehicles,
      employees: employees ?? this.employees,
      selectedDay: selectedDay ?? this.selectedDay,
      selectedDayInWeekView: selectedDayInWeekView ?? this.selectedDayInWeekView,
      error: error ?? this.error,
      weekTaskElements: weekTaskElements ?? this.weekTaskElements,
      weekTimeIssueElements: weekTaskIssueElements ?? this.weekTimeIssueElements,
      weekTaskPlanningElements: weekTaskPlanningElements ?? this.weekTaskPlanningElements,
      weekDeliveryPlanningElements: weekDeliveryPlanningElements ?? this.weekDeliveryPlanningElements,
    );
  }
}
