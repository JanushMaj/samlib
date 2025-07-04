import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/domain/models/grafik/impl/time_issue_element.dart';
import 'package:kabast/domain/models/vehicle.dart';
import 'package:kabast/domain/models/employee.dart';
import 'states/week_grafik_data.dart';

class GrafikState {
  final List<TaskElement> tasks;
  final List<TimeIssueElement> issues;
  final Map<String, List<String>> taskTimeIssueDisplayMapping;
  final Map<String, List<String>> taskTransferDisplayMapping;
  final List<Vehicle> vehicles;
  final List<Employee> employees;
  final DateTime selectedDay;
  final DateTime selectedDayInWeekView;
  final String? error;

  final WeekGrafikData weekData;

  GrafikState({
    required this.tasks,
    required this.issues,
    required this.taskTimeIssueDisplayMapping,
    required this.taskTransferDisplayMapping,
    required this.vehicles,
    required this.employees,
    required this.selectedDay,
    required this.selectedDayInWeekView,
    this.error,
    required this.weekData,
  });

  factory GrafikState.initial() {
    final now = DateTime.now();
    // Obliczamy poniedziałek bieżącego tygodnia
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return GrafikState(
      tasks: [],
      issues: [],
      taskTimeIssueDisplayMapping: {},
      taskTransferDisplayMapping: {},
      vehicles: [],
      employees: [],
      selectedDay: now,
      selectedDayInWeekView: monday,
      error: null,
      weekData: WeekGrafikData.initial(),
    );
  }

  GrafikState copyWith({
    List<TaskElement>? tasks,
    List<TimeIssueElement>? issues,
    Map<String, List<String>>? taskTimeIssueDisplayMapping,
    Map<String, List<String>>? taskTransferDisplayMapping,
    List<Vehicle>? vehicles,
    List<Employee>? employees,
    DateTime? selectedDay,
    DateTime? selectedDayInWeekView,
    String? error,
    WeekGrafikData? weekData,
  }) {
    return GrafikState(
      tasks: tasks ?? this.tasks,
      issues: issues ?? this.issues,
      taskTimeIssueDisplayMapping: taskTimeIssueDisplayMapping ?? this.taskTimeIssueDisplayMapping,
      taskTransferDisplayMapping: taskTransferDisplayMapping ?? this.taskTransferDisplayMapping,
      vehicles: vehicles ?? this.vehicles,
      employees: employees ?? this.employees,
      selectedDay: selectedDay ?? this.selectedDay,
      selectedDayInWeekView: selectedDayInWeekView ?? this.selectedDayInWeekView,
      error: error ?? this.error,
      weekData: weekData ?? this.weekData,
    );
  }
}
