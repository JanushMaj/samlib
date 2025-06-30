import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';

class EnumChoiceChip<T extends Enum> extends StatelessWidget {
  final T value;
  final bool isSelected;
  final VoidCallback onSelected;
  final double maxFontSize;

  const EnumChoiceChip({
    Key? key,
    required this.value,
    required this.isSelected,
    required this.onSelected,
    this.maxFontSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ChoiceChip(
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: cs.primary,
      backgroundColor: cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: isSelected ? cs.primary : Colors.grey.shade300,
        ),
      ),
      labelPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      label: Text(
        _formatEnumLabel(value),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isSelected ? cs.onPrimary : cs.onSurface,
        ),
      ),
    );
  }

  String _formatEnumLabel(T val) {
    final name = val.name;
    return name[0].toUpperCase() + name.substring(1);
  }
}
