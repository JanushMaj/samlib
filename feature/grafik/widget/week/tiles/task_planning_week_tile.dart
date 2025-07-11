import 'package:flutter/material.dart';
import 'package:kabast/domain/models/grafik/impl/task_planning_element.dart';
import 'package:kabast/domain/models/grafik/grafik_element_data.dart';
import 'package:kabast/shared/grafik_element_card.dart';
import 'package:kabast/shared/turbo_grid/turbo_grid.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile_delegate.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile_variant.dart';

import '../../../../../theme/size_variants.dart';

class TaskPlanningWeekTile extends StatelessWidget {
  final TaskPlanningElement taskPlanning;
  final GrafikElementData data;

  const TaskPlanningWeekTile({
    Key? key,
    required this.taskPlanning,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TurboGrid(
      tiles: [
        TurboTile(
          priority: 1,
          required: true,
          delegate: _TaskPlanningCardDelegate(taskPlanning, data),
        ),
      ],
    );
  }
}

class _TaskPlanningCardDelegate extends TurboTileDelegate {
  final TaskPlanningElement taskPlanning;
  final GrafikElementData data;

  _TaskPlanningCardDelegate(this.taskPlanning, this.data);

  @override
  List<TurboTileVariant> createVariants() => [
        _variant(SizeVariant.big),
        _variant(SizeVariant.medium),
        _variant(SizeVariant.small),
      ];

  TurboTileVariant _variant(SizeVariant v) {
    final width = switch (v) {
      SizeVariant.big => 320.0,
      SizeVariant.medium => 280.0,
      SizeVariant.small => 240.0,
    };
    final height = v.height * 3;
    return TurboTileVariant(
      size: Size(width, height),
      builder: (context) => SizedBox(
        width: width,
        height: height,
        child: GrafikElementCard(
          element: taskPlanning,
          data: data,
          variant: v,
        ),
      ),
    );
  }
}
