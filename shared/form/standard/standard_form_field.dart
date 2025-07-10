import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';

class StandardFormField extends StatelessWidget {
  final String label;
  final Widget child;
  final String? helperText;
  final String? tooltip;

  const StandardFormField({
    Key? key,
    required this.label,
    required this.child,
    this.helperText,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final labelRow = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        if (tooltip != null)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xxs),
            child: Tooltip(
              message: tooltip!,
              child: const Icon(Icons.info_outline, size: 16),
            ),
          ),
      ],
    );

    final helper = helperText != null
        ? Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              helperText!,
              style: theme.textTheme.bodyMedium,
            ),
          )
        : const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelRow,
          const SizedBox(height: AppSpacing.xs),
          child,
          helper,
        ],
      ),
    );
  }
}
