// responsive_chip_list.dart
import 'package:flutter/material.dart';
import 'responsive_chip.dart';

class ResponsiveChipList extends StatelessWidget {
  final List<ResponsiveChip> chips;

  const ResponsiveChipList({
    super.key,
    required this.chips,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      children: chips,
    );
  }
}