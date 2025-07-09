import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';

class SmallChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Widget? icon;

  const SmallChip({
    Key? key,
    required this.label,
    this.onTap,
    this.backgroundColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chipContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs), // 2.0
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xxs), // 1.0
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: AppSpacing.borderThin, // 1.0
                ),
                borderRadius: BorderRadius.circular(AppRadius.sm), // 2.0
              ),
              child: icon,
            ),
          ),
        Flexible(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        // Ograniczamy maksymalną szerokość chipu, aby nie powodował overflow
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.3,
        ),
        margin: const EdgeInsets.all(AppSpacing.xxs), // 1.0
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs, // 2.0
          vertical: AppSpacing.xxs,  // 1.0
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).chipTheme.backgroundColor,
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: AppSpacing.borderThin,
          ),
          borderRadius: BorderRadius.circular(AppRadius.md), // 4.0
        ),
        child: chipContent,
      ),
    );
  }
}
