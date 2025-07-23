import 'package:test/test.dart';

import '../../../domain/models/grafik/impl/supply_run_element.dart';
import '../../../domain/models/grafik/impl/supply_run_to_task_extension.dart';
import '../../../domain/models/grafik/impl/task_element.dart';
import '../../../domain/models/grafik/enums.dart';

void main() {
  test('converts supply run to task element', () {
    final run = SupplyRunElement(
      id: 'r1',
      startDateTime: DateTime(2023, 1, 1, 8),
      endDateTime: DateTime(2023, 1, 1, 10),
      additionalInfo: 'info',
      supplyOrderIds: const ['o1', 'o2'],
      routeDescription: 'route',
      vehicleIds: const ['v1'],
      driverIds: const ['d1'],
      addedByUserId: 'u1',
      addedTimestamp: DateTime(2023, 1, 1),
      closed: false,
    );

    final task = run.toTaskElement(orderId: 'ord', carIds: const ['c1']);

    expect(task.startDateTime, run.startDateTime);
    expect(task.endDateTime, run.endDateTime);
    expect(task.additionalInfo, run.additionalInfo);
    expect(task.addedByUserId, run.addedByUserId);
    expect(task.taskType, GrafikTaskType.Zaopatrzenie);
    expect(task.orderId, 'ord');
    expect(task.carIds, ['c1']);
    expect(task.status, GrafikStatus.Realizacja);
    expect(task.closed, isFalse);
  });
}
