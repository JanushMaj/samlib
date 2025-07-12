import 'domain/models/grafik/grafik_element.dart';
import 'domain/models/grafik/impl/task_element.dart';
import 'domain/models/grafik/impl/task_planning_element.dart';
import 'domain/models/grafik/impl/delivery_planning_element.dart';
import 'domain/models/grafik/impl/time_issue_element.dart';

abstract class GrafikElementCardDelegate {
  String getLabel();
  String getTimeInfo();
  String getDescription();
}

class TaskElementCardDelegate implements GrafikElementCardDelegate {
  final TaskElement task;
  TaskElementCardDelegate(this.task);

  @override
  String getLabel() => task.orderId;

  @override
  String getTimeInfo() => _formatTime(task.startDateTime, task.endDateTime);

  @override
  String getDescription() => task.additionalInfo;
}

class TaskPlanningElementCardDelegate implements GrafikElementCardDelegate {
  final TaskPlanningElement planning;
  TaskPlanningElementCardDelegate(this.planning);

  @override
  String getLabel() => planning.orderId;

  @override
  String getTimeInfo() => _formatTime(planning.startDateTime, planning.endDateTime);

  @override
  String getDescription() => planning.additionalInfo;
}

class DeliveryPlanningElementCardDelegate implements GrafikElementCardDelegate {
  final DeliveryPlanningElement delivery;
  DeliveryPlanningElementCardDelegate(this.delivery);

  @override
  String getLabel() => delivery.orderId;

  @override
  String getTimeInfo() => _formatTime(delivery.startDateTime, delivery.endDateTime);

  @override
  String getDescription() => delivery.additionalInfo;
}

class TimeIssueElementCardDelegate implements GrafikElementCardDelegate {
  final TimeIssueElement issue;
  TimeIssueElementCardDelegate(this.issue);

  @override
  String getLabel() => issue.issueType.name;

  @override
  String getTimeInfo() => _formatTime(issue.startDateTime, issue.endDateTime);

  @override
  String getDescription() => issue.additionalInfo;
}

class GrafikElementCardDelegateRegistry {
  static GrafikElementCardDelegate delegateFor(GrafikElement element) {
    switch (element.runtimeType) {
      case TaskElement:
        return TaskElementCardDelegate(element as TaskElement);
      case TaskPlanningElement:
        return TaskPlanningElementCardDelegate(element as TaskPlanningElement);
      case DeliveryPlanningElement:
        return DeliveryPlanningElementCardDelegate(element as DeliveryPlanningElement);
      case TimeIssueElement:
        return TimeIssueElementCardDelegate(element as TimeIssueElement);
      default:
        throw ArgumentError('Unsupported element type');
    }
  }
}

String _formatTime(DateTime start, DateTime end) {
  final sameDay = start.year == end.year && start.month == end.month && start.day == end.day;
  if (sameDay) {
    final from = '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
    final to = '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
    return '$from – $to';
  }
  final from = '${start.day.toString().padLeft(2, '0')}.${start.month.toString().padLeft(2, '0')}';
  final to = '${end.day.toString().padLeft(2, '0')}.${end.month.toString().padLeft(2, '0')}';
  return '$from – $to';
}
