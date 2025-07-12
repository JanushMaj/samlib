import 'package:flutter/material.dart';
import 'package:kabast/domain/models/grafik/impl/time_issue_element.dart';
import 'package:kabast/domain/models/grafik/grafik_element_data.dart';
import 'package:kabast/shared/grafik_element_card.dart';
import 'package:kabast/shared/turbo_grid/turbo_grid.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile_delegate.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile_variant.dart';

import '../../../../../theme/size_variants.dart';

class TimeIssueWeekTile extends StatelessWidget {
  final TimeIssueElement timeIssue;
  final GrafikElementData data;

  const TimeIssueWeekTile({
    Key? key,
    required this.timeIssue,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return TurboGrid(
          tiles: [
            TurboTile(
              priority: 1,
              required: true,
              delegate: _TimeIssueCardDelegate(timeIssue, data, width, height),
            ),
          ],
        );
      },
    );
  }
}

class _TimeIssueCardDelegate extends TurboTileDelegate {
  final TimeIssueElement timeIssue;
  final GrafikElementData data;
  final double width;
  final double height;

  _TimeIssueCardDelegate(this.timeIssue, this.data, this.width, this.height);

  @override
  List<TurboTileVariant> createVariants() => [
        _variant(SizeVariant.large),
        _variant(SizeVariant.medium),
        _variant(SizeVariant.small),
        _variant(SizeVariant.mini),
      ];

  TurboTileVariant _variant(SizeVariant v) {
    return TurboTileVariant(
      size: Size(width, height),
      builder: (context, constraints) => SizedBox.expand(
        child: GrafikElementCard(
          element: timeIssue,
          data: data,
          variant: v,
        ),
      ),
    );
  }
}
