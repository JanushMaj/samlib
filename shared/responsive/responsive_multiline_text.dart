// responsive_text.dart
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'responsive_element.dart';

class ResponsiveMultilineText extends StatelessWidget with ResponsiveElement {
  final String text;
  @override
  final int priority;
  final TextStyle? style;
  final double minFontSize;
  final double maxFontSize;
  final Color? color;

  const ResponsiveMultilineText({
    super.key,
    required this.text,
    this.priority = 1,
    this.style,
    this.minFontSize = 16,
    this.maxFontSize = 22,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final maxLines = (width ~/ 60).clamp(1, 4);

        return AutoSizeText(
          text,
          maxLines: maxLines,
          minFontSize: minFontSize,
          maxFontSize: maxFontSize,
          style: style?.copyWith(color: color) ?? TextStyle(color: color, fontSize: maxFontSize),
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
