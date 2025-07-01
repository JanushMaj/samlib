import 'package:kabast/domain/models/grafik/impl/delivery_planning_element.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/domain/models/grafik/impl/task_planning_element.dart';
import 'package:kabast/domain/models/grafik/impl/time_issue_element.dart';

class WeekGrafikData {
  final List<TaskElement> taskElements;
  final List<TimeIssueElement> timeIssues;
  final List<TaskPlanningElement> taskPlannings;
  final List<DeliveryPlanningElement> deliveryPlannings;

  WeekGrafikData({
    required this.taskElements,
    required this.timeIssues,
    required this.taskPlannings,
    required this.deliveryPlannings,
  });

  factory WeekGrafikData.initial() => WeekGrafikData(
        taskElements: [],
        timeIssues: [],
        taskPlannings: [],
        deliveryPlannings: [],
      );

  WeekGrafikData copyWith({
    List<TaskElement>? taskElements,
    List<TimeIssueElement>? timeIssues,
    List<TaskPlanningElement>? taskPlannings,
    List<DeliveryPlanningElement>? deliveryPlannings,
  }) {
    return WeekGrafikData(
      taskElements: taskElements ?? this.taskElements,
      timeIssues: timeIssues ?? this.timeIssues,
      taskPlannings: taskPlannings ?? this.taskPlannings,
      deliveryPlannings: deliveryPlannings ?? this.deliveryPlannings,
    );
  }
}
