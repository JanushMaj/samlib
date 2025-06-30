import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';

class DateTimePickerField extends StatefulWidget {
  final DateTime? initialDate;
  final double initialStartHour;
  final double initialEndHour;
  final ValueChanged<DateTimeRange> onChanged;

  const DateTimePickerField({
    Key? key,
    this.initialDate,
    this.initialStartHour = 7,
    this.initialEndHour = 15,
    required this.onChanged,
  }) : super(key: key);

  @override
  _DateTimePickerFieldState createState() => _DateTimePickerFieldState();
}

class _DateTimePickerFieldState extends State<DateTimePickerField> {
  late DateTime selectedDate;
  late double startHour;
  late double endHour;

  double sliderMin = 6;
  double sliderMax = 16;

  final double absoluteMin = 0;
  final double absoluteMax = 24;

  Timer? _lowerTimer;
  Timer? _upperTimer;
  final Duration throttleDuration = const Duration(milliseconds: 690);

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ??
        DateTime.now().add(const Duration(days: 1));
    startHour = widget.initialStartHour;
    endHour = widget.initialEndHour;
  }

  // ───────────────────────────────────────────────────────────
  //  Synchronizacja z nowymi danymi z Cubita
  // ───────────────────────────────────────────────────────────
  @override
  void didUpdateWidget(covariant DateTimePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // data
    if (widget.initialDate != oldWidget.initialDate &&
        widget.initialDate != null) {
      selectedDate = widget.initialDate!;
    }

    // godziny
    final bool hoursChanged = widget.initialStartHour != oldWidget.initialStartHour ||
        widget.initialEndHour != oldWidget.initialEndHour;

    if (hoursChanged) {
      startHour = widget.initialStartHour;
      endHour = widget.initialEndHour;

      sliderMin = startHour < sliderMin ? startHour.floorToDouble() : sliderMin;
      sliderMax = endHour > sliderMax ? endHour.ceilToDouble() : sliderMax;
    }

    if (hoursChanged || widget.initialDate != oldWidget.initialDate) {
      setState(() {});
    }
  }

  void _onSliderChanged(RangeValues values) {
    setState(() {
      startHour = _roundToQuarter(values.start);
      endHour = _roundToQuarter(values.end);
    });
    _maybeExtendRange();
    _notifyChange();
  }

  double _roundToQuarter(double value) => (value * 4).round() / 4.0;

  void _maybeExtendRange() {
    if (startHour <= sliderMin && sliderMin > absoluteMin) {
      _lowerTimer ??= Timer(throttleDuration, () {
        setState(() {
          sliderMin = (sliderMin - 1).clamp(absoluteMin, sliderMin);
          if (startHour < sliderMin) startHour = sliderMin;
        });
        _lowerTimer = null;
        if (sliderMin > absoluteMin && startHour <= sliderMin) _maybeExtendRange();
      });
    } else {
      _lowerTimer?.cancel();
      _lowerTimer = null;
    }

    if (endHour >= sliderMax && sliderMax < absoluteMax) {
      _upperTimer ??= Timer(throttleDuration, () {
        setState(() {
          sliderMax = (sliderMax + 1).clamp(sliderMax, absoluteMax);
          if (endHour > sliderMax) endHour = sliderMax;
        });
        _upperTimer = null;
        if (sliderMax < absoluteMax && endHour >= sliderMax) _maybeExtendRange();
      });
    } else {
      _upperTimer?.cancel();
      _upperTimer = null;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1994, 12, 17),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('pl', 'PL'), // ← DODAJ TO
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
      _notifyChange();
    }
  }

  void _notifyChange() {
    final startDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      startHour.floor(),
      ((startHour % 1) * 60).round(),
    );
    final endDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      endHour.floor(),
      ((endHour % 1) * 60).round(),
    );
    widget.onChanged(DateTimeRange(start: startDateTime, end: endDateTime));
  }

  String _formatTime(double hour) {
    final h = hour.floor();
    final m = ((hour % 1) * 60).round();
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _lowerTimer?.cancel();
    _upperTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clampedStart = startHour.clamp(sliderMin, sliderMax);
    final clampedEnd = endHour.clamp(sliderMin, sliderMax);
    final currentValues = RangeValues(clampedStart, clampedEnd);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(AppStrings.dateLabel),
            TextButton(
              onPressed: _pickDate,
              child: Text("${selectedDate.toLocal()}".split(' ')[0]),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Zakres czasu: '
              '${_formatTime(currentValues.start)}‑${_formatTime(currentValues.end)}',
        ),
        RangeSlider(
          min: sliderMin,
          max: sliderMax,
          values: currentValues,
          divisions: ((sliderMax - sliderMin) * 4).round(),
          labels: RangeLabels(
            _formatTime(currentValues.start),
            _formatTime(currentValues.end),
          ),
          onChanged: _onSliderChanged,
        ),
      ],
    );
  }
}
