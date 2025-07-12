import 'package:flutter/material.dart';
import '../../../theme/size_variants.dart';
import '../../responsive/responsive_layout.dart';
import '../turbo_tile_delegate.dart';
import '../turbo_tile_variant.dart';

class EmployeeDelegate extends TurboTileDelegate {
  final String fullName;
  final String? role;

  EmployeeDelegate({required this.fullName, this.role});

  @override
  List<TurboTileVariant> createVariants() {
    final width = _responsiveWidth(140);
    return [
      _variant(SizeVariant.large, width),
      _variant(SizeVariant.medium, width),
      _variant(SizeVariant.small, width),
      _variant(SizeVariant.mini, width),
    ];
  }

  TurboTileVariant _variant(SizeVariant v, double width) => TurboTileVariant(
    size: Size(width, v.height),
    builder: (context, constraints) => SizedBox.expand(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: v.iconSize),
          const SizedBox(width: 1),
          Expanded(
            child: Text(
              v == SizeVariant.small ? _shortName(fullName) : fullName,
              style: v.textStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
        ],
      ),
    ),
  );

  String _shortName(String name) {
    final p = name.trim().split(' ');
    return (p.length >= 2) ? '${p[0]} ${p[1][0]}.' : name;
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
