/// Date formatting helpers shared across screens.
/// Provides human readable weekday names and formatted dates.

String weekdayName(DateTime date) {
  const names = [
    'Poniedziałek',
    'Wtorek',
    'Środa',
    'Czwartek',
    'Piątek',
    'Sobota',
    'Niedziela',
  ];
  return names[date.weekday - 1];
}

bool _isSameDate(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String formattedDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));

  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final name = weekdayName(date);

  String suffix = '';
  if (_isSameDate(date, today)) {
    suffix = 'DZISIAJ JEST DZISIAJ';
  } else if (_isSameDate(date, tomorrow)) {
    suffix = 'JUTRO';
  }

  return '$day.$month - $name${suffix.isNotEmpty ? ' $suffix' : ''}';
}
