import 'package:flutter/material.dart';
import 'package:kabast/domain/models/employee.dart';
import 'package:kabast/shared/responsive/responsive_layout.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:kabast/theme/size_variants.dart';
import 'package:kabast/theme/theme.dart';
import 'employee_chip_style_resolver.dart';

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
    final style = const EmployeeChipStyleResolver().styleFor(sizeVariant);
    final padding = EdgeInsets.symmetric(
      horizontal: AppTheme.sizeFor(bp, style.horizontal),
      vertical: AppTheme.sizeFor(bp, style.vertical),
    );
    final textStyle = TextStyle(
      fontSize: AppTheme.sizeFor(bp, style.fontSize),
      height: 1,
    );

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
                  style: textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: surname.substring(1) + rest,
                  style: textStyle.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        padding: padding,
        labelPadding: EdgeInsets.zero,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: Colors.grey.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(style.borderRadius),
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
        padding: EdgeInsets.all(AppTheme.sizeFor(bp, style.vertical)),
        labelPadding: EdgeInsets.zero,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: Text(
          initials,
          style: textStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(style.borderRadius),
        ),
      );
    }
  }
}
