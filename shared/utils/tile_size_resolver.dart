import '../responsive/responsive_layout.dart';
import '../../theme/size_variants.dart';

/// Determines [SizeVariant] for tiles based on available space.
class TileSizeResolver {
  static const double _bigWidthThreshold = 300;
  static const double _mediumWidthThreshold = 260;

  static const double _bigHeightThreshold = 44;
  static const double _mediumHeightThreshold = 28;

  /// Returns the [SizeVariant] that should be used for a tile given
  /// available width, height or breakpoint.
  static SizeVariant resolve({
    double? width,
    double? height,
    Breakpoint? breakpoint,
  }) {
    if (breakpoint != null) {
      switch (breakpoint) {
        case Breakpoint.large:
          return SizeVariant.big;
        case Breakpoint.medium:
          return SizeVariant.medium;
        case Breakpoint.small:
          return SizeVariant.small;
      }
    }
    if (width != null) {
      if (width >= _bigWidthThreshold) return SizeVariant.big;
      if (width >= _mediumWidthThreshold) return SizeVariant.medium;
      return SizeVariant.small;
    }
    if (height != null) {
      if (height >= _bigHeightThreshold) return SizeVariant.big;
      if (height >= _mediumHeightThreshold) return SizeVariant.medium;
      return SizeVariant.small;
    }
    return SizeVariant.small;
  }
}
