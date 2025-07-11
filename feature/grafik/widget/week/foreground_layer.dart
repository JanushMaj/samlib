import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/domain/models/grafik/grafik_element.dart';
import 'package:kabast/domain/models/grafik/impl/task_planning_element.dart';
import 'package:kabast/domain/models/grafik/impl/delivery_planning_element.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/domain/models/grafik/impl/time_issue_element.dart';
import 'package:kabast/domain/models/grafik/grafik_element_data.dart';
import 'package:kabast/feature/grafik/widget/week/tiles/default_week_tile.dart';
import 'package:kabast/feature/grafik/widget/week/tiles/delivery_planning_week_tile.dart';
import 'package:kabast/feature/grafik/widget/week/tiles/task_planning_week_tile.dart';
import 'package:kabast/feature/grafik/widget/week/tiles/task_week_tile.dart';
import 'package:kabast/feature/grafik/widget/week/tiles/time_issue_week_tile.dart';

import '../../cubit/grafik_cubit.dart';
import '../../cubit/grafik_state.dart';
import '../../../date/date_cubit.dart';
import 'grafik_grid.dart';

class ForegroundLayer extends StatelessWidget {
  const ForegroundLayer({Key? key}) : super(key: key);

  GrafikElementData _taskData(GrafikState state, TaskElement task) {
    final assignments =
        state.assignments.where((a) => a.taskId == task.id).toList();
    final employees = state.employees
        .where((e) => assignments.any((a) => a.workerId == e.uid))
        .toList();
    final vehicles =
        state.vehicles.where((v) => task.carIds.contains(v.id)).toList();
    return GrafikElementData(
      assignedEmployees: employees,
      assignedVehicles: vehicles,
      assignments: assignments,
    );
  }

  GrafikElementData _taskPlanningData(GrafikState state) {
    return const GrafikElementData(
      assignedEmployees: [],
      assignedVehicles: [],
    );
  }

  GrafikElementData _deliveryPlanningData(GrafikState state) {
    return const GrafikElementData(
      assignedEmployees: [],
      assignedVehicles: [],
    );
  }

  GrafikElementData _timeIssueData(GrafikState state, TimeIssueElement issue) {
    final employees =
        state.employees.where((e) => e.uid == issue.workerId).toList();
    return GrafikElementData(
      assignedEmployees: employees,
      assignedVehicles: const [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GrafikCubit, GrafikState>(
      builder: (context, state) {
        final startDate = context.watch<DateCubit>().state.selectedDayInWeekView;
        final planningElements = <GrafikElement>[
          ...state.weekData.taskPlannings,
          ...state.weekData.deliveryPlannings,
          ...state.weekData.taskElements,
          ...state.weekData.timeIssues,
        ];

        return GrafikGrid(
          startDate: startDate,
          dayCount: 5,
          // wyświetlamy 5 dni (poniedziałek - piątek)
          elements: planningElements,
          labelBuilder: (elem) => "",
          // fallback – nieużywany, gdy przekazany jest weekTileBuilder
          weekTileBuilder: (elem) {
            if (elem is TaskPlanningElement) {
              return TaskPlanningWeekTile(
                taskPlanning: elem,
                data: _taskPlanningData(state),
              );
            } else if (elem is DeliveryPlanningElement) {
              return DeliveryPlanningWeekTile(
                deliveryPlanning: elem,
                data: _deliveryPlanningData(state),
              );
            } else if (elem is TaskElement) {
              return TaskWeekTile(
                task: elem,
                data: _taskData(state, elem),
              );
            } else if (elem is TimeIssueElement) {
              return TimeIssueWeekTile(
                timeIssue: elem,
                data: _timeIssueData(state, elem),
              );
            } else {
              return DefaultWeekTile(element: elem);
            }
          },
        );
      },
    );
  }
}