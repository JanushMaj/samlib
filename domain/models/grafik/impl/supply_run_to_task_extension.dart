import 'task_element.dart';
import 'supply_run_element.dart';
import '../enums.dart';

/// Conversion from [SupplyRunElement] to [TaskElement].
extension SupplyRunToTask on SupplyRunElement {
  /// Create a [TaskElement] representing this supply run.
  ///
  /// [orderId] and [carIds] must be provided to satisfy the task data.
  TaskElement toTaskElement({
    required String orderId,
    GrafikStatus status = GrafikStatus.Realizacja,
    List<String> carIds = const [],
  }) {
    return TaskElement(
      id: '',
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      additionalInfo: additionalInfo,
      orderId: orderId,
      status: status,
      taskType: GrafikTaskType.Zaopatrzenie,
      carIds: carIds,
      addedByUserId: addedByUserId,
      addedTimestamp: addedTimestamp,
      closed: false,
    );
  }
}
