import 'package:flutter/material.dart';
import 'package:kabast/theme/size_variants.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile_delegate.dart';
import 'package:kabast/shared/turbo_grid/turbo_tile_variant.dart';

class EmployeeDelegate extends TurboTileDelegate {
  final String fullName;
  final String? role;

  EmployeeDelegate({required this.fullName, this.role});

  @override
  List<TurboTileVariant> createVariants() => [
    _variant(SizeVariant.big,   140),
    _variant(SizeVariant.medium,140),
    _variant(SizeVariant.small, 140),
  ];

  TurboTileVariant _variant(SizeVariant v, double width) => TurboTileVariant(
    size: Size(width, v.height),
    builder: (context) => SizedBox(
      height: v.height,
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
}
