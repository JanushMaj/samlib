import '../grafik_element.dart';
import '../enums.dart';

/// Service request reported by a user.
///
/// Unlike [TaskElement], this element represents a request that is not yet
/// scheduled on the grafik.
class ServiceRequestElement extends GrafikElement {
  final String location;
  final String description;
  final String orderNumber;
  final ServiceUrgency urgency;
  final DateTime? suggestedDate;
  final Duration estimatedDuration;
  final int requiredPeopleCount;
  final GrafikTaskType taskType;

  ServiceRequestElement({
    required String id,
    required String createdBy,
    required DateTime createdAt,
    required this.location,
    required this.description,
    required this.orderNumber,
    this.urgency = ServiceUrgency.normal,
    this.suggestedDate,
    required this.estimatedDuration,
    required this.requiredPeopleCount,
    this.taskType = GrafikTaskType.Serwis,
  }) : super(
          id: id,
          startDateTime: suggestedDate ?? createdAt,
          endDateTime:
              (suggestedDate ?? createdAt).add(estimatedDuration),
          type: 'ServiceRequestElement',
          additionalInfo: description,
          addedByUserId: createdBy,
          addedTimestamp: createdAt,
          closed: false,
        );
}
