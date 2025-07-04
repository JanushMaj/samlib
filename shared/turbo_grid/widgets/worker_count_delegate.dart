import 'package:flutter/material.dart';
import 'package:kabast/theme/size_variants.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile_delegate.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile_variant.dart';

class WorkerCountDelegate extends TurboTileDelegate {
  final int workerCount;

  WorkerCountDelegate(this.workerCount);

  @override
  List<TurboTileVariant> createVariants() => [
    _variant(SizeVariant.big,   80),
    _variant(SizeVariant.medium,80),
    _variant(SizeVariant.small, 80),
  ];

  TurboTileVariant _variant(SizeVariant v, double width) => TurboTileVariant(
    size: Size(width, v.height),
    builder: (context) => SizedBox(
      height: v.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: v.iconSize),
          const SizedBox(width: 1),
          Text('$workerCount', style: v.textStyle),
        ],
      ),
    ),
  );
}