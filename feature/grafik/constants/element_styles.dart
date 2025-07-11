import 'package:flutter/material.dart';

class GrafikElementStyle {
  final Color backgroundColor;
  final IconData? badgeIcon;
  final Color? badgeColor;

  const GrafikElementStyle({
    required this.backgroundColor,
    this.badgeIcon,
    this.badgeColor,
  });
}

class GrafikElementStyleResolver {
  const GrafikElementStyleResolver();

  GrafikElementStyle styleFor(String type) {
    switch (type) {
      case 'TaskElement':
        return GrafikElementStyle(
          backgroundColor: Colors.lightBlue.shade100,
        );
      case 'TaskPlanningElement':
        return GrafikElementStyle(
          backgroundColor: Colors.green.shade100,
          badgeIcon: Icons.priority_high,
          badgeColor: Colors.red.shade700,
        );
      case 'DeliveryPlanningElement':
        return GrafikElementStyle(
          backgroundColor: Colors.orange.shade100,
        );
      case 'TimeIssueElement':
        return GrafikElementStyle(
          backgroundColor: Colors.red.shade100,
        );
      default:
        return GrafikElementStyle(
          backgroundColor: Colors.grey.shade200,
        );
    }
  }
}
