import 'package:flutter/material.dart';
import 'package:kabast/domain/models/grafik/impl/delivery_planning_element.dart';
import 'package:kabast/domain/models/grafik/grafik_element_data.dart';
import 'package:kabast/shared/grafik_element_card.dart';
import 'package:kabast/shared/turbo_grid/turbo_grid.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile_delegate.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile_variant.dart';

import '../../../../../theme/size_variants.dart';

class DeliveryPlanningWeekTile extends StatelessWidget {
  final DeliveryPlanningElement deliveryPlanning;
  final GrafikElementData data;

  const DeliveryPlanningWeekTile({
    Key? key,
    required this.deliveryPlanning,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TurboGrid(
      tiles: [
        TurboTile(
          priority: 1,
          required: true,
          delegate: _DeliveryPlanningCardDelegate(deliveryPlanning, data),
        ),
      ],
    );
  }
}

class _DeliveryPlanningCardDelegate extends TurboTileDelegate {
  final DeliveryPlanningElement deliveryPlanning;
  final GrafikElementData data;

  _DeliveryPlanningCardDelegate(this.deliveryPlanning, this.data);

  @override
  List<TurboTileVariant> createVariants() => [
        _variant(SizeVariant.large),
        _variant(SizeVariant.medium),
        _variant(SizeVariant.small),
        _variant(SizeVariant.mini),
      ];

  TurboTileVariant _variant(SizeVariant v) {
    final width = switch (v) {
      SizeVariant.large => 320.0,
      SizeVariant.medium => 280.0,
      SizeVariant.small => 240.0,
      SizeVariant.mini => 200.0,
    };
    final height = v.height * 3;
    return TurboTileVariant(
      size: Size(width, height),
      builder: (context) => SizedBox(
        width: width,
        height: height,
        child: GrafikElementCard(
          element: deliveryPlanning,
          data: data,
          variant: v,
        ),
      ),
    );
  }
}
