import 'package:flutter/material.dart';

import '../../../feature/grafik/form/delivery_planning_element_fields.dart';
import '../../../feature/grafik/form/task_element_fields.dart';
import '../../../feature/grafik/form/task_planning_element_fields.dart';
import '../../../feature/grafik/form/time_issue_element_fields.dart';
import 'impl/delivery_planning_element.dart';
import 'impl/task_element.dart';
import 'impl/task_planning_element.dart';
import 'impl/time_issue_element.dart';
import 'grafik_element.dart';

typedef GrafikElementFormBuilder = Widget Function(GrafikElement);

class GrafikElementRegistry {
  static final Map<String, GrafikElementFormBuilder> _formBuilders = {
    'TimeIssueElement': (e) => TimeIssueFields(element: e as TimeIssueElement),
    'DeliveryPlanningElement': (e) => DeliveryPlanningFields(element: e as DeliveryPlanningElement),
    'TaskElement': (e) => TaskFields(element: e as TaskElement),
    'TaskPlanningElement': (e) => GrafikPlanningFields(element: e as TaskPlanningElement),
  };


  static Widget buildFormFields(GrafikElement element) {
    final builder = _formBuilders[element.type];
    if (builder == null) {
      debugPrint('[GrafikElementRegistry] Brak formularza dla typu: ${element.type}');
      return const SizedBox.shrink();
    }
    return builder(element);
  }

  static List<String> getRegisteredTypes() => _formBuilders.keys.toList();

  static GrafikElement createDefaultElementForType(String type) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    final start = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 7);
    final end = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 15);

    switch (type) {
      case 'TimeIssueElement':
        return TimeIssueElement(
          id: '',
          startDateTime: start,
          endDateTime: end,
          additionalInfo: '',
          issueType: TimeIssueType.Spoznienie,
          issuePaymentType: PaymentType.zero,
          workerId: '',
          addedByUserId: '',
          addedTimestamp: DateTime.now(),
          closed: false,
        );
      case 'DeliveryPlanningElement':
        return DeliveryPlanningElement(
          id: '',
          startDateTime: start,
          endDateTime: end,
          additionalInfo: '',
          orderId: '',
          category: DeliveryPlanningCategory.Inne,
          addedByUserId: '',
          addedTimestamp: DateTime.now(),
          closed: false,
        );
      case 'TaskPlanningElement':
        return TaskPlanningElement(
          id: '',
          startDateTime: start,
          endDateTime: end,
          additionalInfo: '',
          workerCount: 1,
          orderId: '',
          probability: GrafikProbability.Pewne,
          taskType: GrafikTaskType.Inne,
          minutes: 60,
          highPriority: false,
          workerIds: const [],
          addedByUserId: '',
          addedTimestamp: DateTime.now(),
          closed: false,
        );
      case 'TaskElement':
      default:
        return TaskElement(
          id: '',
          startDateTime: start,
          endDateTime: end,
          additionalInfo: '',
          workerIds: const [],
          orderId: '',
          status: GrafikStatus.Realizacja,
          taskType: GrafikTaskType.Inne,
          carIds: const [],
          addedByUserId: '',
          addedTimestamp: DateTime.now(),
          closed: false,
        );
    }
  }
}
