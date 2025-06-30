import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/models/grafik/impl/task_template.dart';
import '../cubit/form/grafik_element_form_cubit.dart';

class TaskTemplatesRow extends StatelessWidget {
  const TaskTemplatesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: kTaskTemplates.map((tpl) {
        return ElevatedButton(
          onPressed: () =>
              context.read<GrafikElementFormCubit>().applyTemplate(tpl),
          child: Text(tpl.label),
        );
      }).toList(),
    );
  }
}
