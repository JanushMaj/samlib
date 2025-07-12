import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../theme/size_variants.dart';
import '../turbo_tile_delegate.dart';
import '../turbo_tile_variant.dart';

class ClockViewDelegate extends TurboTileDelegate {
  final DateTime start;
  final DateTime end;

  ClockViewDelegate({required this.start, required this.end});

  @override
  List<TurboTileVariant> createVariants() => [
    _variant(SizeVariant.large, 120),
    _variant(SizeVariant.medium, 100),
    _variant(SizeVariant.small, 80),
    _variant(SizeVariant.mini, 60),
  ];

  // ---------------------------------------------------------------------------
  TurboTileVariant _variant(SizeVariant v, double width) => TurboTileVariant(
    size: Size(width, v.height),
    builder: (c, constraints) {
      final same = _sameDay();
      final fmt = same ? DateFormat.Hm() : DateFormat('dd.MM');

      final from = Text(fmt.format(start), style: v.textStyle);
      final to   = Text(fmt.format(end),   style: v.textStyle);

      return SizedBox.expand(
        child: same
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                from,
                const SizedBox(width: 1),
                Icon(Icons.arrow_right_alt, size: v.iconSize),
                const SizedBox(width: 1),
                to,
              ],
            )
            : Text(
              "${fmt.format(start)} - ${fmt.format(end)}",
              style: v.textStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
      );
    },
  );

  bool _sameDay() =>
      start.year == end.year && start.month == end.month && start.day == end.day;
}
