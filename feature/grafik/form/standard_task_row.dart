import 'package:flutter/material.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/shared/responsive/responsive_layout.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:kabast/theme/theme.dart';

import '../widget/task/template_task_card.dart';
import '../widget/dialog/grafik_element_popup.dart';

class StandardTaskRow extends StatelessWidget {
  final List<TaskElement> standardTasks;

  const StandardTaskRow({Key? key, required this.standardTasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bp = context.breakpoint;

    return Container(
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = bp == Breakpoint.small ? 1 : 2;
          final spacing = AppSpacing.sm;
          final cardWidth =
              (constraints.maxWidth - spacing * (columns - 1)) / columns;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: standardTasks.map((task) {
              return SizedBox(
                width: cardWidth,
                child: GestureDetector(
                  onTap: () => showGrafikElementPopup(context, task),
                  child: TemplateTaskCard(task: task),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
