import 'package:flutter/material.dart';

import 'app_color.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    colorScheme: AppColorScheme.light,
    scaffoldBackgroundColor: AppColors.background,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.onSurface,
      elevation: 0,
      centerTitle: false,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceContainer,

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      hintStyle: const TextStyle(color: AppColors.onSurfaceVariant),

      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.outline, width: 1),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: AppColors.primary,

        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,

        side: const BorderSide(color: AppColors.outline),

        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,

        elevation: 0,

        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.outlineVariant),
      ),
    ),
  );
}
