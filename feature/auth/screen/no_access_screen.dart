import 'package:flutter/material.dart';
import 'package:kabast/shared/appbar/grafik_appbar.dart';
import 'package:kabast/theme/app_tokens.dart';

class NoAccessScreen extends StatelessWidget {
  const NoAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: GrafikAppBar(title: Text(AppStrings.noAccessTitle, style: theme.titleLarge)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm * 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.noAccessMessage,
                style: theme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm * 3),
              Text(
                AppStrings.noAccessInstructions,
                textAlign: TextAlign.center,
                style: theme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.sm * 6),
              Text(
                '💩',
                style: theme.bodyLarge?.copyWith(fontSize: 64),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
