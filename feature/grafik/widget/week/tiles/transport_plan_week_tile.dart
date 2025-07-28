import 'package:flutter/material.dart';
import 'package:kabast/domain/models/supplies/transport_plan.dart';
import 'package:kabast/domain/models/grafik/grafik_element_data.dart';
import 'package:kabast/shared/grafik_element_card.dart';
import 'package:kabast/shared/turbo_grid/turbo_grid.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile_delegate.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile_variant.dart';

import '../../../../../theme/size_variants.dart';

class TransportPlanWeekTile extends StatelessWidget {
  final TransportPlan plan;
  final GrafikElementData data;

  const TransportPlanWeekTile({
    Key? key,
    required this.plan,
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
              delegate: _TransportPlanCardDelegate(plan, data, width, height),
            ),
          ],
        );
      },
    );
  }
}

class _TransportPlanCardDelegate extends TurboTileDelegate {
  final TransportPlan plan;
  final GrafikElementData data;
  final double width;
  final double height;

  _TransportPlanCardDelegate(this.plan, this.data, this.width, this.height);

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
          element: plan,
          data: data,
          variant: v,
        ),
      ),
    );
  }
}
