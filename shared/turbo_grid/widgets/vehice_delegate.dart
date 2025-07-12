import 'package:flutter/material.dart';
import '../../../domain/models/vehicle.dart';
import '../../../theme/size_variants.dart';
import '../turbo_tile_delegate.dart';
import '../turbo_tile_variant.dart';

class VehicleDelegate extends TurboTileDelegate {
  final Vehicle vehicle;

  VehicleDelegate(this.vehicle);

  @override
  List<TurboTileVariant> createVariants() => [
    _variant(SizeVariant.large, 220),
    _variant(SizeVariant.medium, 180),
    _variant(SizeVariant.small, 150),
    _variant(SizeVariant.mini, 120),
  ];

  TurboTileVariant _variant(SizeVariant v, double width) => TurboTileVariant(
    size: Size(width, v.height),
    builder: (context, constraints) => SizedBox(
      height: v.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _icon(vehicle.type, v.iconSize),
          const SizedBox(width: 1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(vehicle.brand,
                    style: v.textStyle,
                    overflow: TextOverflow.ellipsis),
                if (v != SizeVariant.small)
                  Text(vehicle.model,
                      style: v.textStyle,
                      overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 1),
          Text(vehicle.color,
              style: v.textStyle,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    ),
  );


  Widget _icon(VehicleType t, double s) => switch (t) {
    VehicleType.osobowka  => Icon(Icons.directions_car, size: s),
    VehicleType.dostawczy => Icon(Icons.local_shipping, size: s),
    _                     => Icon(Icons.fire_truck,     size: s),
  };
}