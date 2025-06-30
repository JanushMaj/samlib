import 'package:flutter/material.dart';
import '../../../theme/size_variants.dart';
import '../turbo_tile_delegate.dart';
import '../turbo_tile_variant.dart';

class WorkTimePlanningDelegate extends TurboTileDelegate {
  final int workerCount;
  final int minutes; // łączny czas pracy w minutach

  WorkTimePlanningDelegate({required this.workerCount, required this.minutes});

  @override
  List<TurboTileVariant> createVariants() => [
    _variant(SizeVariant.big,   200),
    _variant(SizeVariant.medium,200),
    _variant(SizeVariant.small, 200),
  ];

  TurboTileVariant _variant(SizeVariant v, double width) => TurboTileVariant(
    size: Size(width, v.height),
    builder: (c) => SizedBox(
      height: v.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: v.iconSize),
          const SizedBox(width: 1),
          Text('$workerCount', style: v.textStyle),
          const SizedBox(width: 1),
          Text(_workTimeString(), style: v.textStyle,
              maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    ),
  );

  String _workTimeString() {
    final h = minutes ~/ 60;
    if (h < 8) return '$h godz';
    final d = h ~/ 8;
    final hr = h % 8;
    return hr > 0 ? '$d dni $hr godz' : '$d dni';
  }
}