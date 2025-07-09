import 'package:flutter/material.dart';

/// Rozmiary kafelków (widok tygodniowy i inne gridy).
enum SizeVariant { big, medium, small }

extension SizeVariantSpec on SizeVariant {
  double get _scale {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final width = view.physicalSize.width / view.devicePixelRatio;
    return (width / 400).clamp(0.8, 1.2);
  }

  /// Wysokość kafelka ‑ **musi być taka sama** we wszystkich delegatach.
  double get height => switch (this) {
    SizeVariant.big    => 48 * _scale,
    SizeVariant.medium => 32 * _scale,
    SizeVariant.small  => 20 * _scale,
  };

  /// Domyślny rozmiar ikon.
  double get iconSize => switch (this) {
    SizeVariant.big    => 20 * _scale,
    SizeVariant.medium => 16 * _scale,
    SizeVariant.small  => 14 * _scale,
  };

  /// Spójny styl tekstu (height = 1 ⇒ brak dodatkowego leadingu).
  TextStyle get textStyle => switch (this) {
    SizeVariant.big    => TextStyle(fontSize: 18 * _scale, height: 1),
    SizeVariant.medium => TextStyle(fontSize: 14 * _scale, height: 1),
    SizeVariant.small  => TextStyle(fontSize: 12 * _scale, height: 1),
  };
}
