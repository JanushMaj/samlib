import '../responsive/responsive_layout.dart';
import '../../theme/size_variants.dart';

/// Determines [SizeVariant] for tiles based on available space.
class TileSizeResolver {
  static const double _largeWidthThreshold = 320;
  static const double _mediumWidthThreshold = 280;
  static const double _smallWidthThreshold = 240;

  static const double _largeHeightThreshold = 44;
  static const double _mediumHeightThreshold = 28;
  static const double _smallHeightThreshold = 20;

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
          return SizeVariant.large;
        case Breakpoint.medium:
          return SizeVariant.medium;
        case Breakpoint.small:
          return SizeVariant.small;
      }
    }
    if (width != null) {
      if (width >= _largeWidthThreshold) return SizeVariant.large;
      if (width >= _mediumWidthThreshold) return SizeVariant.medium;
      if (width >= _smallWidthThreshold) return SizeVariant.small;
      return SizeVariant.mini;
    }
    if (height != null) {
      if (height >= _largeHeightThreshold) return SizeVariant.large;
      if (height >= _mediumHeightThreshold) return SizeVariant.medium;
      if (height >= _smallHeightThreshold) return SizeVariant.small;
      return SizeVariant.mini;
    }
    return SizeVariant.small;
  }
}
