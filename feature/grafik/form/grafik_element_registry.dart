import 'package:flutter/material.dart';

import 'delivery_planning_element_fields.dart';
import 'task_element_fields.dart';
import 'task_planning_element_fields.dart';
import 'time_issue_element_fields.dart';
import 'supply_run_element_fields.dart';
import 'strategy/delivery_planning_element_strategy.dart';
import 'strategy/task_element_strategy.dart';
import 'strategy/task_planning_element_strategy.dart';
import 'strategy/time_issue_element_strategy.dart';
import 'strategy/supply_run_element_strategy.dart';
import '../../../domain/models/grafik/impl/delivery_planning_element.dart';
import '../../../domain/models/grafik/impl/task_element.dart';
import '../../../domain/models/grafik/impl/task_planning_element.dart';
import '../../../domain/models/grafik/impl/time_issue_element.dart';
import '../../../domain/models/grafik/impl/supply_run_element.dart';
import '../../../domain/models/grafik/grafik_element.dart';
import 'strategy/grafik_element_form_strategy.dart';

typedef GrafikElementFormBuilder = Widget Function(GrafikElement);

class GrafikElementRegistry {
  static final Map<String, GrafikElementFormBuilder> _formBuilders = {
    'TimeIssueElement': (e) => TimeIssueFields(element: e as TimeIssueElement),
    'DeliveryPlanningElement': (e) => DeliveryPlanningFields(element: e as DeliveryPlanningElement),
    'TaskElement': (e) => TaskFields(element: e as TaskElement),
    'TaskPlanningElement': (e) => GrafikPlanningFields(element: e as TaskPlanningElement),
    'SupplyRunElement': (e) => SupplyRunFields(element: e as SupplyRunElement),
  };

  static final Map<String, GrafikElementFormStrategy> _strategies = {
    'TimeIssueElement': TimeIssueElementStrategy(),
    'DeliveryPlanningElement': DeliveryPlanningElementStrategy(),
    'TaskElement': TaskElementStrategy(),
    'TaskPlanningElement': TaskPlanningElementStrategy(),
    'SupplyRunElement': SupplyRunElementStrategy(),
  };


  static Widget buildFormFields(GrafikElement element) {
    final builder = _formBuilders[element.type];
    if (builder == null) {
      return const SizedBox.shrink();
    }
    return builder(element);
  }

  static List<String> getRegisteredTypes() => _formBuilders.keys.toList();

  static GrafikElementFormStrategy getStrategyForType(String type) {
    return _strategies[type] ?? TaskElementStrategy();
  }

  static GrafikElement createDefaultElementForType(String type) {
    return getStrategyForType(type).createDefault();
  }
}
