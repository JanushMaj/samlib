import 'package:flutter/material.dart';

/// Rozmiary kafelków (widok tygodniowy i inne gridy).
enum SizeVariant { big, medium, small }

extension SizeVariantSpec on SizeVariant {
  /// Wysokość kafelka ‑ **musi być taka sama** we wszystkich delegatach.
  double get height => switch (this) {
    SizeVariant.big    => 48,  // px
    SizeVariant.medium => 32,
    SizeVariant.small  => 20,
  };

  /// Domyślny rozmiar ikon.
  double get iconSize => switch (this) {
    SizeVariant.big    => 20,
    SizeVariant.medium => 16,
    SizeVariant.small  => 14,
  };

  /// Spójny styl tekstu (height = 1 ⇒ brak dodatkowego leadingu).
  TextStyle get textStyle => switch (this) {
    SizeVariant.big    => const TextStyle(fontSize: 18, height: 1),
    SizeVariant.medium => const TextStyle(fontSize: 14, height: 1),
    SizeVariant.small  => const TextStyle(fontSize: 12, height: 1),
  };
}
