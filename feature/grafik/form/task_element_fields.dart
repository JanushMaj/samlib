import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kabast/feature/grafik/form/task_templates_row.dart';
import 'package:kabast/theme/app_tokens.dart';

import '../../../domain/models/grafik/enums.dart';
import '../../../domain/models/grafik/impl/task_element.dart';
import '../../../shared/form/custom_textfield.dart';
import '../../../shared/form/enum_picker/enum_picker.dart';
import '../../emplyee/emplyee_picker.dart';
import '../../vehicle/widget/vehicle_picker.dart';
import '../cubit/form/grafik_element_form_cubit.dart';
import '../../../../data/repositories/emplyee_repository.dart';
import '../../../../data/repositories/vehicle_repository.dart';

class TaskFields extends StatelessWidget {
  final TaskElement element;
  const TaskFields({Key? key, required this.element}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final missing = (element.expectedWorkerCount ?? 0) - element.workerIds.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ───── info z planu ─────
        if (element.expectedWorkerCount != null) ...[
          Text(
            'Planowano: ${element.expectedWorkerCount} pracowników '
                '(${missing > 0 ? "brakuje $missing" : "obsada pełna"})',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
        ],
        if (element.plannedMinutes != null) ...[
          Text(
            'Planowany czas: ${element.plannedMinutes} min',
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 16),
        ],
        const TaskTemplatesRow(),
        // Order ID
        CustomTextField(
          label: 'Nr Zlecenia',
          initialValue: element.orderId,
          onChanged: (val) => context.read<GrafikElementFormCubit>()
              .updateField('orderId', val.toString()),
        ),
        const SizedBox(height: AppSpacing.sm * 2), // 4*2=8


        // Task Type
        EnumPicker<GrafikTaskType>(
          label: 'Typ zadania',
          values: GrafikTaskType.values,
          initialValue: element.taskType,
          onChanged: (val) => context.read<GrafikElementFormCubit>()
              .updateField('taskType', val.toString()),
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
        VehiclePicker(
          vehicleStream: GetIt.I<VehicleRepository>().getVehicles(),
          initialSelectedIds: element.carIds,
          onSelectionChanged: (selectedVehicles) {
            final ids = selectedVehicles.map((v) => v.id).toList();
            context.read<GrafikElementFormCubit>().updateField('carIds', ids);
          },
        ),
      ],
    );
  }
}
