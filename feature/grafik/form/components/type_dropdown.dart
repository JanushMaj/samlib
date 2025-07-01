import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/models/grafik/grafik_element.dart';
import '../../../../domain/models/grafik/grafik_element_registry.dart';
import '../../cubit/form/grafik_element_form_cubit.dart';

class TypeDropdown extends StatelessWidget {
  final GrafikElement element;
  const TypeDropdown({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    final types = GrafikElementRegistry.getRegisteredTypes();
    final mapping = {
      'TaskElement': 'Zadanie',
      'TaskPlanningElement': 'Planowane zadanie',
      'TimeIssueElement': 'Czas Pracy',
      'DeliveryPlanningElement': 'Dostawa',
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<String>(
          value: element.type,
          underline: const SizedBox(),
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.blueAccent,
            size: 42.0,
          ),
          items: types.map((t) {
            return DropdownMenuItem(
              value: t,
              child: Text(
                mapping[t] ?? t,
                style: const TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              context.read<GrafikElementFormCubit>().updateField('type', val);
            }
          },
        ),
      ],
    );
  }
}
