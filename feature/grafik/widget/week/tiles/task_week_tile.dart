import 'package:flutter/material.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile.dart';
import 'package:kabast/shared/turbo_grid/turbo_grid.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile_delegate.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile_variant.dart';
import 'package:kabast/shared/task_card.dart';
import '../../../../../theme/app_tokens.dart';
import '../../../../../theme/size_variants.dart';
import '../../dialog/grafik_element_popup.dart';
import '../../../constants/element_styles.dart';

class TaskWeekTile extends StatelessWidget {
  final TaskElement task;
  const TaskWeekTile({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = const GrafikElementStyleResolver().styleFor(task.type);
    return GestureDetector(
      onTap: () => showGrafikElementPopup(context, task),
      child: Container(
        decoration: BoxDecoration(
          color: style.backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return TurboGrid(
              tiles: [
                TurboTile(
                  priority: 1,
                  required: true,
                  delegate: _TaskCardDelegate(task),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TaskCardDelegate extends TurboTileDelegate {
  final TaskElement task;
  _TaskCardDelegate(this.task);

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
        child: TaskCard(
          task: task,
          showEmployees: v != SizeVariant.small,
          showVehicles: v != SizeVariant.small,
        ),
      ),
    );
  }
}
