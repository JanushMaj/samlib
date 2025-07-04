// lib/feature/vehicle/widget/vehicle_tile_simple.dart
import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:kabast/domain/models/vehicle.dart';

class VehicleTileSimple extends StatelessWidget {
  final Vehicle vehicle;
  final bool isSelected;
  final VoidCallback onTap;

  const VehicleTileSimple({
    Key? key,
    required this.vehicle,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Zamiast .withOpacity(0.1), używamy withAlpha(AppSpacing.alphaLow)
    final bgColor = isSelected
        ? Theme.of(context).colorScheme.primary.withAlpha(AppSpacing.alphaLow)
        : Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor;

    final borderColor = isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).dividerColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm), // 4.0
        margin: const EdgeInsets.all(AppSpacing.xs * 2), // 2 * 2 = 4.0
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.lg), // 8.0
          border: Border.all(
            color: borderColor,
            width: AppSpacing.borderThin, // 1.0
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${vehicle.brand} ${vehicle.model}',
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
            // Odstęp 4 px
            const SizedBox(height: AppSpacing.sm),
            // "Kolor: ${vehicle.color}"
            Text(
              '${AppStrings.color}: ${vehicle.color}',
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
            if (vehicle.nrRejestracyjny.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${AppStrings.registrationNumber}: ${vehicle.nrRejestracyjny}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
