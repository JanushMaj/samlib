import 'package:flutter/material.dart';

import '../permission/permission_widget.dart';
import '../../shared/custom_fab.dart';

class PlanSupplyRunFAB extends StatelessWidget {
  const PlanSupplyRunFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return PermissionWidget(
      permission: 'canPlanSupplyRun',
      child: CustomFAB(
        icon: Icons.local_shipping,
        onPressed: () => Navigator.pushNamed(context, '/planSupplyRun'),
      ),
    );
  }
}
