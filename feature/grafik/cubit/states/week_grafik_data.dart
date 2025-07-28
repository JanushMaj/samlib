import 'package:kabast/domain/models/grafik/impl/delivery_planning_element.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/domain/models/grafik/impl/task_planning_element.dart';
import 'package:kabast/domain/models/grafik/impl/time_issue_element.dart';
import 'package:kabast/domain/models/grafik/impl/supply_run_element.dart';
import 'package:kabast/domain/models/grafik/impl/transport_plan.dart';

class WeekGrafikData {
  final List<TaskElement> taskElements;
  final List<TimeIssueElement> timeIssues;
  final List<TaskPlanningElement> taskPlannings;
  final List<DeliveryPlanningElement> deliveryPlannings;
  final List<SupplyRunElement> supplyRuns;
  final List<TransportPlan> transportPlans;

  WeekGrafikData({
    required this.taskElements,
    required this.timeIssues,
    required this.taskPlannings,
    required this.deliveryPlannings,
    required this.supplyRuns,
    required this.transportPlans,
  });

  factory WeekGrafikData.initial() => WeekGrafikData(
        taskElements: [],
        timeIssues: [],
        taskPlannings: [],
        deliveryPlannings: [],
        supplyRuns: [],
        transportPlans: [],
      );

  WeekGrafikData copyWith({
    List<TaskElement>? taskElements,
    List<TimeIssueElement>? timeIssues,
    List<TaskPlanningElement>? taskPlannings,
    List<DeliveryPlanningElement>? deliveryPlannings,
    List<SupplyRunElement>? supplyRuns,
    List<TransportPlan>? transportPlans,
  }) {
    return WeekGrafikData(
      taskElements: taskElements ?? this.taskElements,
      timeIssues: timeIssues ?? this.timeIssues,
      taskPlannings: taskPlannings ?? this.taskPlannings,
      deliveryPlannings: deliveryPlannings ?? this.deliveryPlannings,
      supplyRuns: supplyRuns ?? this.supplyRuns,
      transportPlans: transportPlans ?? this.transportPlans,
    );
  }
}
