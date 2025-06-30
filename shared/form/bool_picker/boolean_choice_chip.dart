import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';

class BooleanChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double maxFontSize;

  const BooleanChoiceChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.maxFontSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ChoiceChip(
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: colorScheme.primary,
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: isSelected ? colorScheme.primary : Colors.grey.shade300,
        ),
      ),
      labelPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
    );
  }
}
