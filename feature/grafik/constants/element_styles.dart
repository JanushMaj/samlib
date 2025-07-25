import 'package:flutter/material.dart';

class GrafikElementStyle {
  final Color backgroundColor;
  final Color borderColor;
  final IconData? badgeIcon;
  final Color? badgeColor;

  const GrafikElementStyle({
    required this.backgroundColor,
    required this.borderColor,
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
          borderColor: Colors.lightBlue,
        );
      case 'TaskPlanningElement':
        return GrafikElementStyle(
          backgroundColor: Colors.green.shade100,
          borderColor: Colors.green,
          badgeIcon: Icons.priority_high,
          badgeColor: Colors.red.shade700,
        );
      case 'DeliveryPlanningElement':
        return GrafikElementStyle(
          backgroundColor: Colors.orange.shade100,
          borderColor: Colors.orange,
        );
      case 'SupplyRunElement':
        return const GrafikElementStyle(
          backgroundColor: Color(0xFFD9B99B),
          borderColor: Color(0xFF8A6C4F),
          badgeIcon: Icons.shopping_cart,
        );
      case 'TimeIssueElement':
        return GrafikElementStyle(
          backgroundColor: Colors.red.shade100,
          borderColor: Colors.red,
        );
      default:
        return GrafikElementStyle(
          backgroundColor: Colors.grey.shade200,
          borderColor: Colors.grey,
        );
    }
  }
}
