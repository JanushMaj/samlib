import 'package:flutter/material.dart';
import '../../../theme/size_variants.dart';
import '../../responsive/responsive_layout.dart';
import '../turbo_tile_delegate.dart';
import '../turbo_tile_variant.dart';

class WorkTimePlanningDelegate extends TurboTileDelegate {
  final int workerCount;
  final int minutes; // łączny czas pracy w minutach

  WorkTimePlanningDelegate({required this.workerCount, required this.minutes});

  @override
  List<TurboTileVariant> createVariants() {
    final width = _responsiveWidth(200);
    return [
      _variant(SizeVariant.big, width),
      _variant(SizeVariant.medium, width),
      _variant(SizeVariant.small, width),
    ];
  }

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
          Flexible(
            child: Text(
              _workTimeString(),
              style: v.textStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
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

  double _responsiveWidth(double base) {
    final bp = _currentBreakpoint();
    switch (bp) {
      case Breakpoint.small:
        return base * 0.8;
      case Breakpoint.medium:
        return base;
      case Breakpoint.large:
        return base * 1.2;
    }
  }

  Breakpoint _currentBreakpoint() {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final width = view.physicalSize.width / view.devicePixelRatio;
    if (width < 600) return Breakpoint.small;
    if (width < 1000) return Breakpoint.medium;
    return Breakpoint.large;
  }
}