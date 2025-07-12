import 'package:flutter/material.dart';
import 'package:kabast/shared/grafik_card_delegate.dart';

import '../domain/models/grafik/grafik_element.dart';
import '../domain/models/grafik/grafik_element_data.dart';
import '../domain/models/employee.dart';
import '../domain/models/vehicle.dart';
import '../feature/grafik/constants/element_styles.dart';
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        final w = constraints.maxWidth;

        // Height driven layout decisions
        final showEmployees = h > 40;
        final showFullNames = h > 80 && w > 200;
        final showTime = h > 100;
        final showDescription = h > 130;
        final multiLineDescription = h > 160;

        final children = <Widget>[
          Text(label, style: variant.textStyle, overflow: TextOverflow.ellipsis),
          if (showEmployees && data.assignedEmployees.isNotEmpty)
            _employeeRow(context, showFullNames, variant),
          if (showTime)
            Text(time,
                style: variant.textStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
        ];

        if (showDescription) {
          children.add(
            Text(
              description,
              style: variant.textStyle,
              maxLines: multiLineDescription ? 3 : 1,
              overflow: multiLineDescription
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
            ),
          );
        }

        return SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(
              color: style.backgroundColor,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...children,
                const Spacer(),
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
      children: chips,
    );
  }
}


