import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/grafik/enums.dart';
import '../../../domain/models/grafik/impl/delivery_planning_element.dart';
import '../../../shared/form/custom_textfield.dart';
import '../../../shared/form/enum_picker/enum_picker.dart';
import '../cubit/form/grafik_element_form_cubit.dart';

// Nowy import z tokenami
import 'package:kabast/theme/app_tokens.dart';

class DeliveryPlanningFields extends StatelessWidget {
  final DeliveryPlanningElement element;

  const DeliveryPlanningFields({Key? key, required this.element}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTextField(
          label: 'Order ID',
          initialValue: element.orderId,
          onChanged: (val) => context
              .read<GrafikElementFormCubit>()
              .updateField('orderId', val.toString()),
        ),
        const SizedBox(height: AppSpacing.sm * 2), // 4*2=8

        EnumPicker<DeliveryPlanningCategory>(
          label: 'Kategoria',
          values: DeliveryPlanningCategory.values,
          initialValue: element.category,
          onChanged: (val) => context
              .read<GrafikElementFormCubit>()
              .updateField('category', val.toString()),
        ),
      ],
    );
  }
}
