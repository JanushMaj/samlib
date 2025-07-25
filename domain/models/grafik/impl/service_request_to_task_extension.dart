import 'task_element.dart';
import 'service_request_element.dart';
import '../enums.dart';

/// Conversion from [ServiceRequestElement] to [TaskElement].
extension ServiceRequestToTask on ServiceRequestElement {
  /// Create a [TaskElement] representing this service request.
  TaskElement toTaskElement({
    GrafikStatus status = GrafikStatus.Realizacja,
    List<String> carIds = const [],
  }) {
    return TaskElement(
      id: '',
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      additionalInfo: description,
      orderId: orderNumber,
      status: status,
      taskType: GrafikTaskType.Serwis,
      carIds: carIds,
      addedByUserId: addedByUserId,
      addedTimestamp: addedTimestamp,
      closed: false,
    );
  }
}
