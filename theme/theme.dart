import 'package:flutter/material.dart';
import 'app_tokens.dart';

class AppTheme {
  static ThemeData buildTheme() {
    return ThemeData(
      useMaterial3: false,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1565C0),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1565C0),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1565C0)),
        actionsIconTheme: const IconThemeData(color: Color(0xFF1565C0)),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 22),
        bodyMedium: TextStyle(fontSize: 20),
        bodySmall: TextStyle(fontSize: 18),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //Wykorzystywane turbo_grid
        displaySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        displayLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
        labelStyle: const TextStyle(
          fontSize: 16,
          color: Color(0xFF1565C0),
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