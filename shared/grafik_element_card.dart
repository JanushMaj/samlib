import 'package:flutter/material.dart';

import '../domain/models/grafik/grafik_element.dart';
import '../domain/models/grafik/grafik_element_data.dart';
import '../domain/models/grafik/impl/task_element.dart';
import '../domain/models/grafik/impl/task_planning_element.dart';
import '../domain/models/grafik/impl/delivery_planning_element.dart';
import '../domain/models/grafik/impl/time_issue_element.dart';
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

    Widget child;
    if (element is TaskElement) {
      child = _buildTask(element as TaskElement);
    } else if (element is TaskPlanningElement) {
      child = _buildTaskPlanning(element as TaskPlanningElement);
    } else if (element is DeliveryPlanningElement) {
      child = _buildDeliveryPlanning(element as DeliveryPlanningElement);
    } else if (element is TimeIssueElement) {
      child = _buildTimeIssue(element as TimeIssueElement);
    } else {
      child = const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: child,
    );
  }

  Widget _buildTask(TaskElement task) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return TurboGrid(
          tiles: [
            TurboTile(
              priority: 1,
              required: true,
              delegate: ClockViewDelegate(
                start: task.startDateTime,
                end: task.endDateTime,
              ),
            ),
            TurboTile(
              priority: 1,
              required: true,
              delegate: SimpleTextDelegate(text: task.additionalInfo),
            ),
            if (data.assignedEmployees.isNotEmpty)
              TurboTile(
                priority: 2,
                required: false,
                delegate: _EmployeeChipRowDelegate(data.assignedEmployees),
              ),
            if (data.assignedVehicles.isNotEmpty)
              TurboTile(
                priority: 3,
                required: false,
                delegate: _VehicleChipRowDelegate(data.assignedVehicles),
              ),
            TurboTile(
              priority: 4,
              required: false,
              delegate: SimpleTextDelegate(text: task.orderId),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaskPlanning(TaskPlanningElement planning) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tiles = [
          TurboTile(
            priority: 1,
            required: true,
            delegate: ClockViewDelegate(
              start: planning.startDateTime,
              end: planning.endDateTime,
            ),
          ),
          TurboTile(
            priority: 1,
            required: true,
            delegate: SimpleTextDelegate(text: planning.additionalInfo),
          ),
          TurboTile(
            priority: 2,
            required: false,
            delegate: SimpleTextDelegate(text: planning.orderId),
          ),
          TurboTile(
            priority: 3,
            required: false,
            delegate: SimpleTextDelegate(
              text: planning.probability.toString(),
            ),
          ),
          TurboTile(
            priority: 4,
            required: false,
            delegate: SimpleTextDelegate(text: planning.taskType.name),
          ),
          TurboTile(
            priority: 5,
            required: false,
            delegate: WorkTimePlanningDelegate(
              workerCount: planning.workerCount,
              minutes: planning.minutes,
            ),
          ),
        ];
        return Stack(
          children: [
            TurboGrid(tiles: tiles),
            if (planning.highPriority)
              Positioned(
                bottom: 4,
                right: 4,
                child: const Icon(Icons.priority_high, size: 18),
              ),
          ],
        );
      },
    );
  }

  Widget _buildDeliveryPlanning(DeliveryPlanningElement delivery) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return TurboGrid(
          tiles: [
            TurboTile(
              priority: 1,
              required: true,
              delegate: ClockViewDelegate(
                start: delivery.startDateTime,
                end: delivery.endDateTime,
              ),
            ),
            TurboTile(
              priority: 1,
              required: true,
              delegate: SimpleTextDelegate(text: delivery.additionalInfo),
            ),
            TurboTile(
              priority: 3,
              required: true,
              delegate: SimpleTextDelegate(text: delivery.orderId),
            ),
            TurboTile(
              priority: 4,
              required: true,
              delegate: SimpleTextDelegate(text: delivery.category.name),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimeIssue(TimeIssueElement issue) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return TurboGrid(
          tiles: [
            TurboTile(
              priority: 1,
              required: true,
              delegate: ClockViewDelegate(
                start: issue.startDateTime,
                end: issue.endDateTime,
              ),
            ),
            TurboTile(
              priority: 1,
              required: true,
              delegate: SimpleTextDelegate(text: issue.additionalInfo),
            ),
            if (data.assignedEmployees.isNotEmpty)
              TurboTile(
                priority: 2,
                required: true,
                delegate: _EmployeeChipRowDelegate(data.assignedEmployees),
              ),
            TurboTile(
              priority: 3,
              required: false,
              delegate: SimpleTextDelegate(text: issue.issueType.name),
            ),
          ],
        );
      },
    );
  }
}

class _EmployeeChipRowDelegate extends TurboTileDelegate {
  final List<Employee> employees;

  _EmployeeChipRowDelegate(this.employees);

  @override
  List<TurboTileVariant> createVariants() => [
        _variant(SizeVariant.big, 80.0 * employees.length),
        _variant(SizeVariant.medium, 70.0 * employees.length),
        _variant(SizeVariant.small, 60.0 * employees.length),
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
        _variant(SizeVariant.big, 100.0 * vehicles.length),
        _variant(SizeVariant.medium, 90.0 * vehicles.length),
        _variant(SizeVariant.small, 80.0 * vehicles.length),
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

