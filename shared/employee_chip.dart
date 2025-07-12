import 'package:flutter/material.dart';
import 'package:kabast/domain/models/employee.dart';
import 'package:kabast/shared/responsive/responsive_layout.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:kabast/theme/size_variants.dart';
import 'package:kabast/theme/theme.dart';

class EmployeeChip extends StatelessWidget {
  final Employee employee;
  final bool? showFullName;
  final SizeVariant sizeVariant;

  const EmployeeChip({
    super.key,
    required this.employee,
    this.showFullName,
    this.sizeVariant = SizeVariant.small,
  });

  @override
  Widget build(BuildContext context) {
    final bp = context.breakpoint;
    final bool full = showFullName ?? bp != Breakpoint.small;
    double scale() {
      switch (sizeVariant) {
        case SizeVariant.large:
          return 1.5;
        case SizeVariant.medium:
          return 1.2;
        case SizeVariant.small:
          return 1.0;
        case SizeVariant.mini:
          return 0.8;
      }
    }

    final paddingScale = scale();

    if (full) {
      final name = employee.formattedNameWithSecondInitial;
      final parts = name.split(' ');
      final surname = parts.first;
      final rest = name.substring(surname.length);
      return Chip(
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: surname.substring(0, 1),
                  style: sizeVariant.textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: surname.substring(1) + rest,
                  style: sizeVariant.textStyle.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.sizeFor(bp, 2 * paddingScale),
          vertical: AppTheme.sizeFor(bp, 1 * paddingScale),
        ),
        labelPadding: EdgeInsets.zero,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: Colors.grey.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      );
    } else {
      final initials = employee.fullName
          .split(' ')
          .where((e) => e.isNotEmpty)
          .map((e) => e[0])
          .take(2)
          .join();
      return Chip(
        padding: EdgeInsets.all(AppTheme.sizeFor(bp, 1 * paddingScale)),
        labelPadding: EdgeInsets.zero,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: Text(
          initials,
          style: sizeVariant.textStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      );
    }
  }
}
