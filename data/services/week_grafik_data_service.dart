import 'package:rxdart/rxdart.dart';

import '../../domain/models/employee.dart';
import '../../domain/models/grafik/grafik_element.dart';
import '../../domain/models/grafik/impl/delivery_planning_element.dart';
import '../../domain/models/grafik/impl/task_element.dart';
import '../../domain/models/grafik/impl/task_planning_element.dart';
import '../../domain/models/grafik/impl/time_issue_element.dart';
import '../repositories/grafik_element_repository.dart';
import '../repositories/employee_repository.dart';
import '../../feature/grafik/cubit/states/week_grafik_data.dart';

class WeekGrafikDataService {
  final GrafikElementRepository _grafikRepo;
  final EmployeeRepository _employeeRepo;

  WeekGrafikDataService(this._grafikRepo, this._employeeRepo);

  Stream<WeekGrafikData> loadWeek(DateTime monday) {
    final friday = monday.add(const Duration(
        days: 4, hours: 23, minutes: 59, seconds: 59, milliseconds: 999));

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

    return Rx.combineLatest2<List<GrafikElement>, List<Employee>, WeekGrafikData>(
        grafikStream, employeeStream, (elements, employees) {
      final taskElements = elements.whereType<TaskElement>().toList();
      final timeIssues = elements.whereType<TimeIssueElement>().toList();
      final taskPlannings = elements.whereType<TaskPlanningElement>().toList();
      final deliveryPlannings =
          elements.whereType<DeliveryPlanningElement>().toList();

      return WeekGrafikData(
        taskElements: taskElements,
        timeIssues: timeIssues,
        taskPlannings: taskPlannings,
        deliveryPlannings: deliveryPlannings,
      );
    });
  }
}
