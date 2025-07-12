import 'package:flutter/material.dart';
import '../../../theme/size_variants.dart';
import '../turbo_tile_delegate.dart';
import '../turbo_tile_variant.dart';

class SimpleTextDelegate extends TurboTileDelegate {
  final String text;
  final double maxWidth;

  SimpleTextDelegate({required this.text, this.maxWidth = 300});

  @override
  List<TurboTileVariant> createVariants() => [
    _build(SizeVariant.large),
    _build(SizeVariant.medium, maxLines: 3),
    _build(SizeVariant.small, maxLines: 1),
    _build(SizeVariant.mini, maxLines: 1),
  ];

  TurboTileVariant _build(SizeVariant v, {int? maxLines}) {
    final measured = _measure(text, v.textStyle, maxWidth, maxLines);
    final size = Size(measured.width, v.height);

    return TurboTileVariant(
      size: size,
      builder: (context, constraints) => SizedBox.expand(
        child: Text(
          text,
          style: v.textStyle,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      ),
    );
  }

  Size _measure(String txt, TextStyle style, double maxW, int? ml) {
    final tp = TextPainter(
      text: TextSpan(text: txt, style: style),
      textDirection: TextDirection.ltr,
      maxLines: ml,
    )..layout(maxWidth: maxW);
    return tp.size;
  }
}