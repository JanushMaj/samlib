import 'package:flutter/material.dart';
import 'background_layer.dart';
import 'foreground_layer.dart';

class GrafikPlanningStack extends StatelessWidget {
  const GrafikPlanningStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        BackgroundLayer(),
        ForegroundLayer(),
        // ewentualnie: GrafikPlanning(),
      ],
    );
  }
}
