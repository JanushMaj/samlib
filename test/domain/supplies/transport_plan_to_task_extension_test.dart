import 'package:test/test.dart';

import '../../../domain/models/supplies/transport_plan.dart';
import '../../../lib/domain/models/supplies/transport_plan_to_task_extension.dart';
import '../../../domain/models/grafik/impl/task_element.dart';
import '../../../domain/models/grafik/enums.dart';

void main() {
  group('TransportPlan toTaskElements', () {
    test('maps dated subtasks to task elements', () {
      final plan = TransportPlan(
        id: 'p1',
        createdBy: 'u1',
        start: DateTime(2024, 1, 1),
        end: DateTime(2024, 1, 1, 23, 59),
        subtasks: [
          TransportSubTask(
            type: TransportSubTaskType.purchase,
            place: 'Store',
            dateTime: DateTime(2024, 1, 1, 8),
            relatedOrderId: 'o1',
          ),
          TransportSubTask(
            type: TransportSubTaskType.delivery,
            place: 'Site',
            dateTime: DateTime(2024, 1, 1, 12),
            note: 'fragile',
            relatedOrderId: 'o2',
          ),
        ],
        comment: 'daily',
      );

      final tasks = plan.toTaskElements();

      expect(tasks, hasLength(2));

      final first = tasks.first;
      expect(first.startDateTime, DateTime(2024, 1, 1, 8));
      expect(first.endDateTime, DateTime(2024, 1, 1, 8));
      expect(first.orderId, 'o1');
      expect(first.taskType, GrafikTaskType.Zaopatrzenie);
      expect(first.status, GrafikStatus.Realizacja);
      expect(first.addedByUserId, plan.createdBy);
    });

    test('summarizes full-day plan with undated subtasks', () {
      final plan = TransportPlan(
        id: 'p2',
        createdBy: 'u2',
        start: DateTime(2024, 2, 1),
        end: DateTime(2024, 2, 1, 23, 59),
        subtasks: [
          TransportSubTask(
            type: TransportSubTaskType.pickup,
            place: 'A',
          ),
          TransportSubTask(
            type: TransportSubTaskType.delivery,
            place: 'B',
          ),
        ],
        comment: 'rounds',
      );

      final tasks = plan.toTaskElements();

      expect(tasks, hasLength(1));
      final t = tasks.single;
      expect(t.startDateTime, plan.start);
      expect(t.endDateTime, plan.end);
      expect(t.additionalInfo.contains('rounds'), isTrue);
      expect(t.additionalInfo.contains('pickup'), isTrue);
      expect(t.taskType, GrafikTaskType.Zaopatrzenie);
    });
  });
}
