import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/models/grafik/enums.dart';
import '../../../../domain/models/grafik/grafik_element.dart';
import '../../../../domain/models/grafik/impl/task_planning_element.dart';
import '../../../../domain/models/grafik/impl/time_issue_element.dart';
import '../../../../shared/datetime/date_range_picker_button.dart';
import '../../../../shared/datetime/date_time_picker_field.dart';
import '../../cubit/form/grafik_element_form_cubit.dart';

class DateInputSelector extends StatelessWidget {
  final GrafikElement element;

  const DateInputSelector({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    final bool isTaskPlanning = element is TaskPlanningElement;
    final bool isPending = isTaskPlanning
        ? (element as TaskPlanningElement).isPending
        : false;

    if (isTaskPlanning && isPending) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Text(
          'Wisi i grozi – brak terminu',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    }

    if (isTaskPlanning ||
        (element is TimeIssueElement &&
            (element as TimeIssueElement).issueType ==
                TimeIssueType.Nieobecnosc)) {
      return DateRangePickerButton(
        initialRange: DateTimeRange(
          start: element.startDateTime,
          end: element.endDateTime,
        ),
        onRangeSelected: (range) {
          context.read<GrafikElementFormCubit>()
              .updateField('startDateTime', range.start);
          context.read<GrafikElementFormCubit>()
              .updateField('endDateTime', range.end);
        },
      );
    }

    return DateTimePickerField(
      initialDate: element.startDateTime,
      initialStartHour: element.startDateTime.hour.toDouble(),
      initialEndHour: element.endDateTime.hour.toDouble(),
      onChanged: (range) {
        context
            .read<GrafikElementFormCubit>()
            .updateField('startDateTime', range.start);
        context
            .read<GrafikElementFormCubit>()
            .updateField('endDateTime', range.end);
      },
    );
  }
}
