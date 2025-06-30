import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';

class ColorChoiceChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const ColorChoiceChip({
    Key? key,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
      selectedColor: color.withOpacity(0.7),
      backgroundColor: color.withOpacity(0.3),
      selected: isSelected,
      onSelected: (_) => onTap(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      labelPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
    );
  }
}
