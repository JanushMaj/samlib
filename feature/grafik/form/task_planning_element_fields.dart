import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kabast/theme/app_tokens.dart';

import 'package:kabast/data/repositories/employee_repository.dart';
import 'package:kabast/domain/models/grafik/enums.dart';
import 'package:kabast/domain/models/grafik/impl/task_planning_element.dart';
import 'package:kabast/shared/form/bool_picker/bool_toggle_field.dart';
import 'package:kabast/shared/form/custom_textfield.dart';
import 'package:kabast/shared/form/enum_picker/enum_picker.dart';
import 'package:kabast/shared/form/minutes_picker/minutes_picker_field.dart';
import 'package:kabast/shared/form/small_number_picker/small_number_picker.dart';
import 'package:kabast/domain/constants/pending_placeholder_date.dart';
import 'package:kabast/feature/employee/employee_picker.dart';
import 'package:kabast/feature/grafik/cubit/form/grafik_element_form_cubit.dart';

class GrafikPlanningFields extends StatelessWidget {
  final TaskPlanningElement element;

  const GrafikPlanningFields({Key? key, required this.element}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTextField(
          label: 'Numer Zlecenia',
          initialValue: element.orderId,
          onChanged: (val) =>
              context.read<GrafikElementFormCubit>().updateField('orderId', val),
        ),
        const SizedBox(height: AppSpacing.sm * 2), // 4*2=8

        SmallNumberPicker(
          initialValue: element.workerCount,
          onChanged: (value) =>
              context.read<GrafikElementFormCubit>().updateField('workerCount', value),
        ),
        const SizedBox(height: AppSpacing.sm * 2),

        EmployeePicker(
          employeeStream: GetIt.I<EmployeeRepository>().getEmployees(),
          initialSelectedIds: element.workerIds,
          onSelectionChanged: (selectedEmployees) {
            final ids = selectedEmployees.map((e) => e.uid).toList();
            context.read<GrafikElementFormCubit>().updateField('workerIds', ids);
          },
        ),
        const SizedBox(height: AppSpacing.sm * 2),

        EnumPicker<GrafikProbability>(
          label: 'Prawdopodobieństwo',
          values: GrafikProbability.values,
          initialValue: element.probability,
          onChanged: (val) => context
              .read<GrafikElementFormCubit>()
              .updateField('probability', val.toString()),
        ),
        const SizedBox(height: AppSpacing.sm * 2),

        EnumPicker<GrafikTaskType>(
          label: 'Typ zadania',
          values: GrafikTaskType.values,
          initialValue: element.taskType,
          onChanged: (val) => context
              .read<GrafikElementFormCubit>()
              .updateField('taskType', val.toString()),
        ),
        const SizedBox(height: AppSpacing.sm * 2),

        MinutesPickerField(
          minutes: element.minutes,
          onChanged: (val) =>
              context.read<GrafikElementFormCubit>().updateField('minutes', val),
        ),
        const SizedBox(height: AppSpacing.sm * 2),
        // ------------- NOWY TOGGLE "Wisi i grozi" -------------
        BoolToggleField(
          label: 'Wisi i grozi',
          value: element.isPending,
          onChanged: (val) {
            final cubit = context.read<GrafikElementFormCubit>();

            // 1. ustawiamy flagę w modelu
            cubit.updateField('isPending', val);

            // 2. dopasowujemy daty
            if (val) {
              cubit.updateField('startDateTime', pendingPlaceholderDate);
              cubit.updateField(
                'endDateTime',
                pendingPlaceholderDate.add(
                  Duration(minutes: element.minutes),
                ),
              );
            } else {
              final now = DateTime.now();
              cubit.updateField('startDateTime', now);
              cubit.updateField('endDateTime', now.add(Duration(minutes: element.minutes)));
            }
          },
        ),
        const SizedBox(height: AppSpacing.sm * 2),

        BoolToggleField(
          label: 'Priorytet?',
          value: element.highPriority,
          onChanged: (val) =>
              context.read<GrafikElementFormCubit>().updateField('highPriority', val),
        ),
      ],
    );
  }
}
