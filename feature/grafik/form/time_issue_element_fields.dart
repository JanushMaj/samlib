import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kabast/theme/app_tokens.dart';

import 'package:kabast/domain/models/grafik/enums.dart';
import 'package:kabast/domain/models/grafik/impl/time_issue_element.dart';
import 'package:kabast/shared/form/enum_picker/enum_picker.dart';
import 'package:kabast/feature/employee/employee_picker.dart';
import 'package:kabast/feature/grafik/cubit/form/grafik_element_form_cubit.dart';
import 'package:kabast/data/repositories/employee_repository.dart';

class TimeIssueFields extends StatelessWidget {
  final TimeIssueElement element;

  const TimeIssueFields({Key? key, required this.element}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        EnumPicker<TimeIssueType>(
          label: 'Typ',
          values: TimeIssueType.values.where((e) => e != TimeIssueType.Nadgodziny).toList(),
          initialValue: element.issueType,
          onChanged: (val) {
            context.read<GrafikElementFormCubit>().updateField('issueType', val.toString());
          },
        ),
        const SizedBox(height: AppSpacing.sm * 2), // 4*2=8

        EmployeePicker(
          singleSelection: true,
          employeeStream: GetIt.I<EmployeeRepository>().getEmployees(),
          initialSelectedIds: [element.workerId],
          onSelectionChanged: (selectedEmployees) {
            final ids = selectedEmployees.map((e) => e.uid).toList();
            context.read<GrafikElementFormCubit>().updateSelectedWorkerIds(ids);
          },
        ),
      ],
    );
  }
}
