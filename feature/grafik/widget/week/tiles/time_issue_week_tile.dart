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
        return TurboGrid(
          tiles: [
            TurboTile(
              priority: 1,
              required: true,
              delegate: _TimeIssueCardDelegate(timeIssue, data, width),
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

  _TimeIssueCardDelegate(this.timeIssue, this.data, this.width);

  @override
  List<TurboTileVariant> createVariants() => [
        _variant(SizeVariant.large),
        _variant(SizeVariant.medium),
        _variant(SizeVariant.small),
        _variant(SizeVariant.mini),
      ];

  TurboTileVariant _variant(SizeVariant v) {
    final height = v.height * 3;
    return TurboTileVariant(
      size: Size(width, height),
      builder: (context) => SizedBox(
        width: width,
        height: height,
        child: GrafikElementCard(
          element: timeIssue,
          data: data,
          variant: v,
        ),
      ),
    );
  }
}
