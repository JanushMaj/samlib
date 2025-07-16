import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/grafik/impl/supply_run_element.dart';
import '../../../shared/form/custom_textfield.dart';
import '../cubit/form/grafik_element_form_cubit.dart';
import '../../../theme/app_tokens.dart';

class SupplyRunFields extends StatelessWidget {
  final SupplyRunElement element;

  const SupplyRunFields({Key? key, required this.element}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTextField(
          label: 'Opis trasy',
          initialValue: element.routeDescription,
          onChanged: (val) =>
              context.read<GrafikElementFormCubit>().updateField('routeDescription', val),
        ),
        const SizedBox(height: AppSpacing.sm * 2),
        CustomTextField(
          label: 'ID zamówień (oddzielone przecinkami)',
          initialValue: element.supplyOrderIds.join(', '),
          onChanged: (val) {
            final ids = val
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
            context.read<GrafikElementFormCubit>().updateField('supplyOrderIds', ids);
          },
        ),
      ],
    );
  }
}
