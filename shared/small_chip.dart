import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';
import "package:kabast/theme/theme.dart";
import 'package:kabast/shared/responsive/responsive_layout.dart';

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
          padding: EdgeInsets.only(
            right: AppSpacing.scaled(AppSpacing.xs, context.breakpoint),
          ),
            child: Container(
              padding: EdgeInsets.all(
                AppSpacing.scaled(AppSpacing.xxs, context.breakpoint),
              ), // 1.0
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
            style: AppTheme.textStyleFor(
              context.breakpoint,
              Theme.of(context).textTheme.bodySmall!,
            ),
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
        margin: EdgeInsets.all(
          AppSpacing.scaled(AppSpacing.xxs, context.breakpoint),
        ), // 1.0
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.scaled(AppSpacing.xs, context.breakpoint),
          vertical: AppSpacing.scaled(AppSpacing.xxs, context.breakpoint),
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
