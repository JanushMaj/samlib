import 'package:flutter/material.dart';
import '../feature/permission/permission_widget.dart';
import 'custom_fab.dart';

class AddGrafikFAB extends StatelessWidget {
  const AddGrafikFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return PermissionWidget(
      permission: 'canAddGrafik',
      child: CustomFAB(
        onPressed: () => Navigator.pushNamed(context, '/addGrafik'),
      ),
    );
  }
}
