import 'package:cloud_firestore/cloud_firestore.dart';
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

typedef GrafikElementDeserializer = GrafikElement Function(Map<String, dynamic>);
typedef GrafikElementFormBuilder = Widget Function(GrafikElement);

class GrafikElementRegistry {
  static final Map<String, GrafikElementDeserializer> _deserializers = {
    'TimeIssueElement': (json) => TimeIssueElement.fromJson(json),
    'DeliveryPlanningElement': (json) => DeliveryPlanningElement.fromJson(json),
    'TaskElement': (json) => TaskElement.fromJson(json),
    'TaskPlanningElement': (json) => TaskPlanningElement.fromJson(json),
  };

  static final Map<String, GrafikElementFormBuilder> _formBuilders = {
    'TimeIssueElement': (e) => TimeIssueFields(element: e as TimeIssueElement),
    'DeliveryPlanningElement': (e) => DeliveryPlanningFields(element: e as DeliveryPlanningElement),
    'TaskElement': (e) => TaskFields(element: e as TaskElement),
    'TaskPlanningElement': (e) => GrafikPlanningFields(element: e as TaskPlanningElement),
  };

  static GrafikElement fromJson(Map<String, dynamic> json) {
    final type = json['type']?.toString() ?? '';
    final deserializer = _deserializers[type];

    if (deserializer == null) {
      debugPrint('[GrafikElementRegistry] Nieznany typ: "$type". Używam fallback.');
      return TimeIssueElement.fromJson({
        ...json,
        'type': 'TimeIssueElement',
        'additionalInfo': 'Nieznany typ: $type',
      });
    }

    return deserializer(json);
  }

  static Widget buildFormFields(GrafikElement element) {
    final builder = _formBuilders[element.type];
    if (builder == null) {
      debugPrint('[GrafikElementRegistry] Brak formularza dla typu: ${element.type}');
      return const SizedBox.shrink();
    }
    return builder(element);
  }

  static List<String> getRegisteredTypes() => _formBuilders.keys.toList();

  static Map<String, dynamic> createDefaultJsonForType(String type) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    final start = Timestamp.fromDate(DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 7));
    final end = Timestamp.fromDate(DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 15));

    switch (type) {
      case 'TimeIssueElement':
        return {
          'id': '',
          'startDateTime': start,
          'endDateTime': end,
          'type': 'TimeIssueElement',
          'additionalInfo': '',
          'reason': 'TimeIssueType.Spoznienie',
          'issuePaymentType': 'PaymentType.zero',
          'workerIds': <String>[],
        };
      case 'DeliveryPlanningElement':
        return {
          'id': '',
          'startDateTime': start,
          'endDateTime': end,
          'type': 'DeliveryPlanningElement',
          'additionalInfo': '',
          'orderId': '',
          'category': 'DeliveryPlanningCategory.Inne',
        };
      case 'TaskPlanningElement':
        return {
          'id': '',
          'startDateTime': start,
          'endDateTime': end,
          'type': 'TaskPlanningElement',
          'additionalInfo': '',
          'workerCount': 1,
          'orderId': '', // poprawka!
          'probability': 'GrafikProbability.Pewne',
          'taskType': 'GrafikTaskType.Inne',
          'minutes': 60,
          'highPriority': false,
        };
      case 'TaskElement':
      default:
        return {
          'id': '',
          'startDateTime': start,
          'endDateTime': end,
          'type': 'TaskElement',
          'additionalInfo': '',
          'workerIds': <String>[],
          'orderId': '',
          'status': 'GrafikStatus.Realizacja',
          'taskType': 'GrafikTaskType.Inne',
          'carIds': <String>[],
        };
    }
  }
}
