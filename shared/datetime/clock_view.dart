import 'package:flutter/material.dart';

class FixedClockView extends StatelessWidget {
  final DateTime start;
  final DateTime end;

  const FixedClockView({
    super.key,
    required this.start,
    required this.end,
  });

  static const double hourWidth = 15.0;
  static const int minHour = 7;
  static const int maxHour = 15;
  static const double padding = 8.0;

  static const double width = hourWidth * (maxHour - minHour) + 2 * padding;
  static const double height = 4+8+2*4;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: ClockViewPainter(
          start: start,
          end: end,
        ),
      ),
    );
  }
}

class ClockViewPainter extends CustomPainter {
  final DateTime start;
  final DateTime end;

  static const double hourWidth = 15.0;
  static const int minHour = 7;
  static const int maxHour = 15;
  static const double padding = 8.0;

  ClockViewPainter({
    required this.start,
    required this.end,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double startX = padding;
    final double endX = size.width - padding;
    final double totalWidth = endX - startX;
    final double lineY = size.height / 2;

    // Tło
    final backgroundPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(startX, lineY),
      Offset(endX, lineY),
      backgroundPaint,
    );

    // Minuty
    final minTimeMinutes = minHour * 60;
    final maxTimeMinutes = maxHour * 60;
    final totalMinutes = maxTimeMinutes - minTimeMinutes;

    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    final clampedStart = startMinutes.clamp(minTimeMinutes, maxTimeMinutes);
    final clampedEnd = endMinutes.clamp(minTimeMinutes, maxTimeMinutes);

    final relativeStart =
        ((clampedStart - minTimeMinutes) / totalMinutes) * totalWidth + startX;
    final relativeEnd =
        ((clampedEnd - minTimeMinutes) / totalMinutes) * totalWidth + startX;

    // Aktywny zakres
    final activePaint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.6)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(relativeStart, lineY),
      Offset(relativeEnd, lineY),
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant ClockViewPainter oldDelegate) {
    return oldDelegate.start != start || oldDelegate.end != end;
  }
}
