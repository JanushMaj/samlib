class DateState {
  final DateTime selectedDay;
  final DateTime selectedDayInWeekView;

  DateState({required this.selectedDay, required this.selectedDayInWeekView});

  factory DateState.initial() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return DateState(selectedDay: now, selectedDayInWeekView: monday);
  }

  DateState copyWith({DateTime? selectedDay, DateTime? selectedDayInWeekView}) {
    return DateState(
      selectedDay: selectedDay ?? this.selectedDay,
      selectedDayInWeekView: selectedDayInWeekView ?? this.selectedDayInWeekView,
    );
  }
}
