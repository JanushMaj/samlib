import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';

class MinutesQuickButtons extends StatelessWidget {
  final int minutes;
  final ValueChanged<int> onChanged;

  const MinutesQuickButtons({
    Key? key,
    required this.minutes,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final labels = {
      '+30min': 30,
      '+1h': 60,
      '+2h': 120,
      '+8h': 480,
    };

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xxs,
      alignment: WrapAlignment.center,
      children: labels.entries.map((entry) {
        return ElevatedButton(
          onPressed: () => onChanged(minutes + entry.value),
          child: Text(entry.key),
        );
      }).toList(),
    );
  }
}
