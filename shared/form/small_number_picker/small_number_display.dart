import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';

class SmallNumberDisplay extends StatelessWidget {
  final int value;

  const SmallNumberDisplay({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Text(
        '$value',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
