import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';

class MinutesPickerField extends StatelessWidget {
  final int minutes;
  final ValueChanged<int> onChanged;

  const MinutesPickerField({
    Key? key,
    required this.minutes,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double hours = minutes / 60.0;
    final double workingDays = hours / 8.0;

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Dodany opis nad panelem
        Text(
          'Roboczogodziny brygady',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Przycisk Zeruj
              TextButton(
                onPressed: () => onChanged(0),
                child: const Text('Zeruj'),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Pole tekstowe wyświetlające czas w godzinach oraz liczbę dni roboczych
              TextButton(
                onPressed: () {
                  // Pokazanie SnackBar z podsumowaniem:
                  final snackBar = SnackBar(
                    content: Text(
                      '${hours.toStringAsFixed(1)} godzin dzieli się na ${workingDays.toStringAsFixed(1)} ośmiogodzinnych dni roboczych',
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: RichText(
                  text: TextSpan(
                    text: '${hours.toStringAsFixed(1)}h',
                    style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                    children: [
                      TextSpan(
                        text: ' (${workingDays.toStringAsFixed(1)})',
                        style: textTheme.bodyLarge?.copyWith(
                          fontSize: (textTheme.bodyLarge?.fontSize ?? 14) * 0.8,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Przyciski dodające odpowiednie wartości
              TextButton(
                onPressed: () => onChanged(minutes + 30), // +0.5h = 30 minut
                child: const Text('+0.5'),
              ),
              const SizedBox(width: AppSpacing.xs),
              TextButton(
                onPressed: () => onChanged(minutes + 60), // +1h = 60 minut
                child: const Text('+1'),
              ),
              const SizedBox(width: AppSpacing.xs),
              TextButton(
                onPressed: () => onChanged(minutes + 240), // +4h = 240 minut
                child: const Text('+4'),
              ),
              const SizedBox(width: AppSpacing.xs),
              TextButton(
                onPressed: () => onChanged(minutes + 480), // +8h = 480 minut
                child: const Text('+8'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
