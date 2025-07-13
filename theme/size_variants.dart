import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Rozmiary kafelków (widok tygodniowy i inne gridy).
enum SizeVariant { large, medium, small, mini }

extension SizeVariantSpec on SizeVariant {
  double get _scale {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final width = view.physicalSize.width / view.devicePixelRatio;
    final shortSide =
        math.min(view.physicalSize.width, view.physicalSize.height) /
            view.devicePixelRatio;
    final base = (width / 400).clamp(0.8, 1.2);
    if (shortSide >= 600) {
      return (shortSide / 600).clamp(1.2, 1.6);
    }
    return base;
  }

  /// Wysokość kafelka ‑ **musi być taka sama** we wszystkich delegatach.
  double get height => switch (this) {
    SizeVariant.large  => 48 * _scale,
    SizeVariant.medium => 32 * _scale,
    SizeVariant.small  => 20 * _scale,
    SizeVariant.mini   => 16 * _scale,
  };

  /// Domyślny rozmiar ikon.
  double get iconSize => switch (this) {
    SizeVariant.large  => 20 * _scale,
    SizeVariant.medium => 16 * _scale,
    SizeVariant.small  => 14 * _scale,
    SizeVariant.mini   => 12 * _scale,
  };

  /// Spójny styl tekstu (height = 1 ⇒ brak dodatkowego leadingu).
  TextStyle get textStyle => switch (this) {
    SizeVariant.large  => TextStyle(fontSize: 18 * _scale, height: 1),
    SizeVariant.medium => TextStyle(fontSize: 14 * _scale, height: 1),
    SizeVariant.small  => TextStyle(fontSize: 12 * _scale, height: 1),
    SizeVariant.mini   => TextStyle(fontSize: 10 * _scale, height: 1),
  };
}
