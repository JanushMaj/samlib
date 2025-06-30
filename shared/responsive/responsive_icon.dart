// responsive_icon.dart
import 'package:flutter/material.dart';

class ResponsiveIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;

  const ResponsiveIcon({
    super.key,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Icon(icon, color: color),
    );
  }
}
