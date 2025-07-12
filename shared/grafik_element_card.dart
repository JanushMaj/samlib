import 'package:flutter/material.dart';

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
import 'turbo_grid/turbo_grid.dart';
import 'turbo_grid/turbo_tile.dart';
import 'turbo_grid/turbo_tile_delegate.dart';
import 'turbo_grid/turbo_tile_variant.dart';
import 'turbo_grid/widgets/clock_view_delegate.dart';
import 'turbo_grid/widgets/simple_text_delegate.dart';
import 'turbo_grid/widgets/vehicle_delegate.dart';
import 'turbo_grid/widgets/employee_delegate.dart';
import 'turbo_grid/widgets/work_time_planning_delegate.dart';

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
        final isVeryNarrow = constraints.maxWidth < 140;
        final isTall = constraints.maxHeight > 120;
        final canShowFullNames = constraints.maxWidth > 200;
        final canShowDescription = isTall;
        final showTime = constraints.maxHeight > 40 && !isVeryNarrow;

        final children = <Widget>[
          Text(label, style: variant.textStyle, overflow: TextOverflow.ellipsis),
          if (data.assignedEmployees.isNotEmpty)
            _employeeRow(context, canShowFullNames, variant),
          if (showTime)
            Text(time,
                style: variant.textStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
        ];

        if (canShowDescription) {
          final multiLine = constraints.maxHeight > 160;
          children.add(
            Text(
              description,
              style: variant.textStyle,
              maxLines: multiLine ? 3 : 1,
              overflow: multiLine
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
            ),
          );
        }

        return Container(
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            color: style.backgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
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
        builder: (context) => SizedBox(
          height: v.height,
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
        builder: (context) => SizedBox(
          height: v.height,
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

