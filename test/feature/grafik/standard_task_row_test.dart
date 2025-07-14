import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kabast/feature/grafik/form/standard_task_row.dart';
import 'package:kabast/feature/grafik/widget/task/template_task_card.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/domain/models/grafik/impl/task_template.dart';
import 'package:kabast/domain/models/grafik/enums.dart';

void main() {
  testWidgets('renders TemplateTaskCard for each standard task', (tester) async {
    final tasks = [
      TaskElement(
        id: '1',
        startDateTime: DateTime(2023, 1, 1, 8),
        endDateTime: DateTime(2023, 1, 1, 9),
        additionalInfo: 'test1',
        orderId: kStandardOrderId,
        status: GrafikStatus.Realizacja,
        taskType: GrafikTaskType.Inne,
        carIds: const [],
        addedByUserId: 'u1',
        addedTimestamp: DateTime(2023, 1, 1),
        closed: false,
      ),
      TaskElement(
        id: '2',
        startDateTime: DateTime(2023, 1, 1, 10),
        endDateTime: DateTime(2023, 1, 1, 11),
        additionalInfo: 'test2',
        orderId: kStandardOrderId,
        status: GrafikStatus.Realizacja,
        taskType: GrafikTaskType.Inne,
        carIds: const [],
        addedByUserId: 'u1',
        addedTimestamp: DateTime(2023, 1, 1),
        closed: false,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(home: StandardTaskRow(standardTasks: tasks)),
    );

    expect(find.byType(TemplateTaskCard), findsNWidgets(tasks.length));
  });
}
