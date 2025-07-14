import 'package:flutter/material.dart';
import '../../../../domain/models/grafik/impl/task_element.dart';
import '../../../../shared/responsive/responsive_layout.dart';
import '../../../../theme/app_tokens.dart';
import '../../../../theme/theme.dart';

class TemplateTaskCard extends StatelessWidget {
  final TaskElement task;
  const TemplateTaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final bp = context.breakpoint;
    final style = AppTheme.textStyleFor(
      bp,
      Theme.of(context).textTheme.bodyMedium!,
    );
    return Container(
      padding: EdgeInsets.all(AppSpacing.scaled(AppSpacing.sm, bp)),
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: Colors.pink.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome, color: Colors.pink),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              task.additionalInfo,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
        ],
      ),
    );
  }
}
