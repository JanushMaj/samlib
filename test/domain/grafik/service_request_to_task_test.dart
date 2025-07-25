import 'package:test/test.dart';

import '../../../domain/models/grafik/impl/service_request_element.dart';
import '../../../domain/models/grafik/impl/service_request_to_task_extension.dart';
import '../../../domain/models/grafik/impl/task_element.dart';
import '../../../domain/models/grafik/enums.dart';

void main() {
  test('converts service request to task element', () {
    final req = ServiceRequestElement(
      id: 'r1',
      createdBy: 'u1',
      createdAt: DateTime(2024, 1, 1),
      location: 'loc',
      description: 'desc',
      orderNumber: 'ord1',
      urgency: ServiceUrgency.normal,
      suggestedDate: DateTime(2024, 1, 2),
      estimatedDuration: const Duration(minutes: 90),
      requiredPeopleCount: 2,
    );

    final task = req.toTaskElement();

    expect(task.startDateTime, req.startDateTime);
    expect(task.endDateTime, req.endDateTime);
    expect(task.additionalInfo, req.description);
    expect(task.orderId, req.orderNumber);
    expect(task.taskType, GrafikTaskType.Serwis);
    expect(task.status, GrafikStatus.Realizacja);
    expect(task.carIds, isEmpty);
    expect(task.addedByUserId, req.addedByUserId);
    expect(task.closed, isFalse);
  });
}
