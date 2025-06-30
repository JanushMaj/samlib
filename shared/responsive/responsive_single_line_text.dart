import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'responsive_element.dart';

class ResponsiveSingleLineText extends StatelessWidget with ResponsiveElement {
  final String text;
  @override
  final int priority;
  final TextStyle? style;
  final double minFontSize;
  final double maxFontSize;
  final Color? color;

  const ResponsiveSingleLineText({
    super.key,
    required this.text,
    this.priority = 1,
    this.style,
    this.minFontSize = 22,
    this.maxFontSize = 26,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      maxLines: 1,
      minFontSize: minFontSize,
      maxFontSize: maxFontSize,
      style: style?.copyWith(color: color) ?? TextStyle(color: color, fontSize: maxFontSize),
      overflow: TextOverflow.ellipsis,
    );
  }
}