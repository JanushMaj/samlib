import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'boolean_choice_chip.dart';

class BoolToggleField extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const BoolToggleField({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: theme.textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: [
            BooleanChoiceChip(
              label: AppStrings.yes,
              isSelected: value == true,
              onTap: () => onChanged(true),
            ),
            BooleanChoiceChip(
              label: AppStrings.no,
              isSelected: value == false,
              onTap: () => onChanged(false),
            ),
          ],
        ),
      ],
    );
  }
}
