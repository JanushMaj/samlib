import 'package:flutter/material.dart';
import 'package:kabast/shared/grafik_card_delegate.dart';

import '../domain/models/grafik/grafik_element.dart';
import '../domain/models/grafik/grafik_element_data.dart';
import '../domain/models/employee.dart';
import '../domain/models/vehicle.dart';
import '../feature/grafik/constants/element_styles.dart';
import '../feature/grafik/constants/enums_ui.dart';
import '../domain/models/grafik/impl/task_element.dart';
import '../domain/models/grafik/impl/task_planning_element.dart';
import '../theme/app_tokens.dart';
import '../theme/size_variants.dart';
import '../theme/theme.dart';
import 'employee_chip.dart';
import 'small_chip.dart';
import 'responsive/responsive_layout.dart';
import 'turbo_grid/turbo_tile_delegate.dart';
import 'turbo_grid/turbo_tile_variant.dart';
class GrafikElementCard extends StatelessWidget {
  final GrafikElement element;
  final GrafikElementData data;
  final SizeVariant variant;

  const GrafikElementCard({
    super.key,
    required this.element,
    required this.data,
    required this.variant,
  });

  @override
  Widget build(BuildContext context) {
    final style = const GrafikElementStyleResolver().styleFor(element.type);
    final delegate = GrafikElementCardDelegateRegistry.delegateFor(element);

    final label = delegate.getLabel();
    final time = delegate.getTimeInfo();
    final description = delegate.getDescription();

    IconData? typeIcon;
    IconData? statusIcon;
    if (element is TaskElement) {
      typeIcon = (element as TaskElement).taskType.icon;
      statusIcon = (element as TaskElement).status.icon;
    } else if (element is TaskPlanningElement) {
      typeIcon = (element as TaskPlanningElement).taskType.icon;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final ts = variant.textStyle;

        // Approximate line height for text rows
        final lineH = ts.fontSize + 4;

        double remaining = constraints.maxHeight;

        final children = <Widget>[];

        // Description first line
        children.add(Text(
          description,
          style: ts,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ));
        remaining -= lineH;

        // Order number / label in bold
        children.add(Text(
          label,
          style: ts.copyWith(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ));
        remaining -= lineH;

        // Employees row - always visible, clipped to two lines
        if (data.assignedEmployees.isNotEmpty) {
          children.add(
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: variant.height * 2),
              child: ClipRect(
                child: _employeeRow(
                  context,
                  w > 200,
                  variant,
                ),
              ),
            ),
          );
          remaining -= variant.height;
        }

        // Time information
        if (remaining > lineH) {
          children.add(
            Text(
              time,
              style: ts,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
          remaining -= lineH;
        }



        final showBadge = style.badgeIcon != null && remaining > variant.iconSize;

        return SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: style.borderColor,
                width: AppSpacing.borderThin,
              ),
            ),
            padding: EdgeInsets.all(
              AppSpacing.scaled(AppSpacing.xs, context.breakpoint),
            ),
            child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (typeIcon != null)
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.xs),
                        child: Icon(
                          typeIcon,
                          size: variant.iconSize,
                          color: style.borderColor,
                        ),
                      ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...children,
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
                if (showBadge)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(
                      style.badgeIcon!,
                      size: variant.iconSize,
                      color: style.badgeColor,
                    ),
                  ),
                if (statusIcon != null)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Icon(
                      statusIcon,
                      size: variant.iconSize,
                      color: style.borderColor,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _employeeRow(
    BuildContext context,
    bool showFullName,
    SizeVariant sizeVariant,
  ) {
    final chips = data.assignedEmployees
        .map<Widget>(
          (e) => EmployeeChip(
            employee: e,
            showFullName: showFullName,
            sizeVariant: sizeVariant,
          ),
        )
        .toList();
    return Wrap(
      spacing: AppTheme.sizeFor(context.breakpoint, 4),
      runSpacing: AppTheme.sizeFor(context.breakpoint, 4),
      clipBehavior: Clip.hardEdge,
      children: chips,
    );
  }
}


