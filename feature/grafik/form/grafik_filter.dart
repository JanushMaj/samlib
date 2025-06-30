import 'package:kabast/domain/models/grafik/enums.dart';

import '../../../domain/models/grafik/impl/delivery_planning_element.dart';
import '../../../domain/models/grafik/impl/task_element.dart';
import '../../../domain/models/grafik/impl/task_planning_element.dart';
import '../../../domain/models/grafik/impl/time_issue_element.dart';

/// Model filtra i funkcja sprawdzająca passFilter.
/// Nie zawiera referencji do styli/kolorów, więc jest OK.
class GrafikFilter {
  final bool showTasks;
  final bool showTimeIssues;
  final bool showTaskPlannings;
  final bool showDeliveries;

  final GrafikStatus? selectedTaskStatus;
  final GrafikTaskType? selectedTaskType;
  final TimeIssueType? selectedIssueReason;

  const GrafikFilter({
    this.showTasks = true,
    this.showTimeIssues = true,
    this.showTaskPlannings = true,
    this.showDeliveries = true,
    this.selectedTaskStatus,
    this.selectedTaskType,
    this.selectedIssueReason,
  });

  GrafikFilter copyWith({
    bool? showTasks,
    bool? showTimeIssues,
    bool? showTaskPlannings,
    bool? showDeliveries,
    GrafikStatus? selectedTaskStatus,
    GrafikTaskType? selectedTaskType,
    TimeIssueType? selectedIssueReason,
    bool resetSelectedTaskStatus = false,
  }) {
    return GrafikFilter(
      showTasks: showTasks ?? this.showTasks,
      showTimeIssues: showTimeIssues ?? this.showTimeIssues,
      showTaskPlannings: showTaskPlannings ?? this.showTaskPlannings,
      showDeliveries: showDeliveries ?? this.showDeliveries,
      selectedTaskStatus: resetSelectedTaskStatus
          ? null
          : (selectedTaskStatus ?? this.selectedTaskStatus),
      selectedTaskType: selectedTaskType ?? this.selectedTaskType,
      selectedIssueReason: selectedIssueReason ?? this.selectedIssueReason,
    );
  }
}

bool passFilter(dynamic el, GrafikFilter filter) {
  if (el is TimeIssueElement) {
    if (!filter.showTimeIssues) return false;
    if (filter.selectedIssueReason != null &&
        el.issueType != filter.selectedIssueReason) {
      return false;
    }
    return true;
  }
  if (el is TaskElement) {
    if (!filter.showTasks) return false;
    if (filter.selectedTaskStatus != null && el.status != filter.selectedTaskStatus) {
      return false;
    }
    if (filter.selectedTaskType != null && el.taskType != filter.selectedTaskType) {
      return false;
    }
    return true;
  }
  if (el is TaskPlanningElement) {
    if (!filter.showTaskPlannings) return false;
    return true;
  }
  if (el is DeliveryPlanningElement) {
    if (!filter.showDeliveries) return false;
    return true;
  }
  // Unknown type
  return false;
}
