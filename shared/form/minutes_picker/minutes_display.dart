import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';

class MinutesDisplay extends StatelessWidget {
  final int minutes;
  final ValueChanged<int> onChanged;

  const MinutesDisplay({
    Key? key,
    required this.minutes,
    required this.onChanged,
  }) : super(key: key);

  String _formatReadableTime(int minutes) {
    final days = minutes ~/ 480;
    final hours = (minutes % 480) ~/ 60;
    final mins = minutes % 60;

    final parts = [
      if (days > 0) '${days}d',
      if (hours > 0) '${hours}h',
      if (mins > 0) '${mins}min',
    ];
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () => onChanged(0),
          child: Text(AppStrings.reset),
        ),
        Text(
          '${(minutes / 60).toStringAsFixed(1)}h',
          style: textTheme.titleLarge,
        ),
        Text(
          _formatReadableTime(minutes),
          style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
        ),
      ],
    );
  }
}
