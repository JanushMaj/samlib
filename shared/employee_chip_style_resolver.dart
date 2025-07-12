import 'package:kabast/theme/app_tokens.dart';
import 'package:kabast/theme/size_variants.dart';

class EmployeeChipStyle {
  final double horizontal;
  final double vertical;
  final double fontSize;
  final double borderRadius;

  const EmployeeChipStyle({
    required this.horizontal,
    required this.vertical,
    required this.fontSize,
    required this.borderRadius,
  });
}

class EmployeeChipStyleResolver {
  const EmployeeChipStyleResolver();

  EmployeeChipStyle styleFor(SizeVariant variant) {
    switch (variant) {
      case SizeVariant.large:
        return const EmployeeChipStyle(
          horizontal: 6,
          vertical: 3,
          fontSize: 16,
          borderRadius: AppRadius.lg,
        );
      case SizeVariant.medium:
        return const EmployeeChipStyle(
          horizontal: 5,
          vertical: 2,
          fontSize: 14,
          borderRadius: AppRadius.md,
        );
      case SizeVariant.small:
        return const EmployeeChipStyle(
          horizontal: 3,
          vertical: 1,
          fontSize: 12,
          borderRadius: AppRadius.sm,
        );
      case SizeVariant.mini:
        return const EmployeeChipStyle(
          horizontal: 2,
          vertical: 0.5,
          fontSize: 10,
          borderRadius: AppRadius.sm,
        );
    }
  }
}
