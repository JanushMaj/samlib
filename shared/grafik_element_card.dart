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
        final w = constraints.maxWidth;
        final ts = variant.textStyle;

        // Approximate line height for text rows
        final lineH = ts.fontSize + 4;

        double remaining = constraints.maxHeight;

        final children = <Widget>[];

        // Order number / label
        children.add(Text(label, style: ts, overflow: TextOverflow.ellipsis));
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

        // Description grows with available space
        final descLines = (remaining / lineH).floor();
        if (descLines > 0) {
          children.add(
            Text(
              description,
              style: ts,
              maxLines: descLines,
              overflow: TextOverflow.ellipsis,
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
      clipBehavior: Clip.hardEdge,
      children: chips,
    );
  }
}

class _EmployeeChipRowDelegate extends TurboTileDelegate {
  final List<Employee> employees;

  _EmployeeChipRowDelegate(this.employees);

  @override
  List<TurboTileVariant> createVariants() => [
        _variant(SizeVariant.large, 80.0 * employees.length),
        _variant(SizeVariant.medium, 70.0 * employees.length),
        _variant(SizeVariant.small, 60.0 * employees.length),
        _variant(SizeVariant.mini, 50.0 * employees.length),
      ];

  TurboTileVariant _variant(SizeVariant v, double width) => TurboTileVariant(
        size: Size(width, v.height),
        builder: (context, constraints) => SizedBox.expand(
          child: Wrap(
            spacing: AppTheme.sizeFor(context.breakpoint, 4),
            runSpacing: AppTheme.sizeFor(context.breakpoint, 4),
            children: employees
                .map((e) => EmployeeChip(
                      employee: e,
                      showFullName: context.breakpoint != Breakpoint.small,
                      sizeVariant: v,
                    ))
                .toList(),
          ),
        ),
      );
}

class _VehicleChipRowDelegate extends TurboTileDelegate {
  final List<Vehicle> vehicles;

  _VehicleChipRowDelegate(this.vehicles);

  @override
  List<TurboTileVariant> createVariants() => [
        _variant(SizeVariant.large, 100.0 * vehicles.length),
        _variant(SizeVariant.medium, 90.0 * vehicles.length),
        _variant(SizeVariant.small, 80.0 * vehicles.length),
        _variant(SizeVariant.mini, 70.0 * vehicles.length),
      ];

  TurboTileVariant _variant(SizeVariant v, double width) => TurboTileVariant(
        size: Size(width, v.height),
        builder: (context, constraints) => SizedBox.expand(
          child: Wrap(
            spacing: AppTheme.sizeFor(context.breakpoint, 4),
            runSpacing: AppTheme.sizeFor(context.breakpoint, 4),
            children: vehicles
                .map(
                  (vehicle) => SmallChip(
                    label: '${vehicle.brand} ${vehicle.color}',
                    icon: _icon(vehicle.type, v.iconSize),
                  ),
                )
                .toList(),
          ),
        ),
      );

  Widget _icon(VehicleType t, double s) => switch (t) {
        VehicleType.osobowka => Icon(Icons.directions_car, size: s),
        VehicleType.dostawczy => Icon(Icons.local_shipping, size: s),
        _ => Icon(Icons.fire_truck, size: s),
      };
}

