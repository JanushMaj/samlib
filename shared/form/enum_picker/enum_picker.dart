import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'enum_choice_chip.dart';

class EnumPicker<T extends Enum> extends StatelessWidget {
  final String label;
  final List<T> values;
  final T? initialValue;
  final void Function(T) onChanged;
  final double maxFontSize;

  const EnumPicker({
    Key? key,
    required this.label,
    required this.values,
    required this.initialValue,
    required this.onChanged,
    this.maxFontSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: theme.textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.xxs),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xxs,
          children: values.map((val) {
            return EnumChoiceChip<T>(
              value: val,
              isSelected: val == initialValue,
              onSelected: () => onChanged(val),
              maxFontSize: maxFontSize,
            );
          }).toList(),
        ),
      ],
    );
  }
}
