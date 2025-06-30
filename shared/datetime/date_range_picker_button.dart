import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';

class DateRangePickerButton extends StatelessWidget {
  final DateTimeRange? initialRange;
  final ValueChanged<DateTimeRange> onRangeSelected;

  const DateRangePickerButton({
    Key? key,
    required this.onRangeSelected,
    this.initialRange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = (initialRange == null)
        ? AppStrings.pickDateRange
        : '${initialRange!.start.toString().split(' ')[0]} - '
        '${initialRange!.end.toString().split(' ')[0]}';

    return TextButton(
      onPressed: () async {
        final now = DateTime.now();
        final range = await showDateRangePicker(
          context: context,
          firstDate: DateTime(now.year - 2),
          lastDate: DateTime(now.year + 2),
          initialDateRange: initialRange,
          locale: const Locale('pl', 'PL'), // ← DODAJ TO
        );
        if (range != null) {
          onRangeSelected(range);
        }
      },
      child: Text(text),
    );
  }
}
