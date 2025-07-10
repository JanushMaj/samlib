import 'package:flutter/material.dart';
import 'app_tokens.dart';
import 'package:kabast/shared/responsive/responsive_layout.dart';

class AppTheme {
  static double _scaleFor(Breakpoint bp) {
    switch (bp) {
      case Breakpoint.small:
        return 0.8;
      case Breakpoint.medium:
        return 1.0;
      case Breakpoint.large:
        return 1.2;
    }
  }

  static TextStyle textStyleFor(Breakpoint bp, TextStyle style) {
    final scale = _scaleFor(bp);
    return style.copyWith(
      fontSize: style.fontSize != null ? style.fontSize! * scale : null,
    );
  }
  static ThemeData buildTheme() {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final width = view.physicalSize.width / view.devicePixelRatio;
    final scale = (width / 400).clamp(0.8, 1.2);

    return ThemeData(
      useMaterial3: false,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1565C0),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 16 * scale,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1565C0),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1565C0)),
        actionsIconTheme: const IconThemeData(color: Color(0xFF1565C0)),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),

      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: 22 * scale),
        bodyMedium: TextStyle(fontSize: 20 * scale),
        bodySmall: TextStyle(fontSize: 18 * scale),
        titleLarge: TextStyle(fontSize: 22 * scale, fontWeight: FontWeight.bold),
        labelLarge: TextStyle(fontSize: 18 * scale, fontWeight: FontWeight.bold),
        //Wykorzystywane turbo_grid
        displaySmall: TextStyle(fontSize: 14 * scale, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 18 * scale, fontWeight: FontWeight.bold),
        displayLarge: TextStyle(fontSize: 22 * scale, fontWeight: FontWeight.bold),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          elevation: 2,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          minimumSize: Size.zero,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          minimumSize: Size.zero,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),

      chipTheme: ChipThemeData(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(
            color: Color(0xFF1565C0),
            width: 0.5,
          ),
        ),
        selectedColor: const Color(0xFF64B5F6),
        backgroundColor: Colors.grey.shade200,
        labelStyle: TextStyle(
          fontSize: 16 * scale,
          color: const Color(0xFF1565C0),
        ),
      ),


      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(AppSpacing.sm),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: Color(0xFF1565C0),)
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF64B5F6),
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      cardTheme: CardTheme(
        elevation: 2,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        margin: const EdgeInsets.all(AppSpacing.xs),
      ),
    );
  }
}