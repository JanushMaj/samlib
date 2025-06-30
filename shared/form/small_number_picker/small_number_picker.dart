import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'small_number_controls.dart';
import 'small_number_display.dart';

class SmallNumberPicker extends StatelessWidget {
  final int initialValue;
  final void Function(int) onChanged;
  final int min;
  final int max;

  const SmallNumberPicker({
    Key? key,
    required this.initialValue,
    required this.onChanged,
    this.min = 0,
    this.max = 17,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final surface = Theme.of(context).colorScheme.surface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // 🧠 najpierw ograniczamy samą kolumnę
      children: [
        Text(AppStrings.numberLabel, style: textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.xs),
        IntrinsicWidth( // 👈 kluczowy dodatek
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // 👈 nie bierz całej szerokości!
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmallNumberControls(
                  direction: ControlDirection.decrease,
                  current: initialValue,
                  min: min,
                  max: max,
                  onChanged: onChanged,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xs, 0, AppSpacing.xs, 0),
                  child: SmallNumberDisplay(value: initialValue),
                ),
                SmallNumberControls(
                  direction: ControlDirection.increase,
                  current: initialValue,
                  min: min,
                  max: max,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
