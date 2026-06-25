import 'package:flutter/material.dart';

class AppColorScheme {
  AppColorScheme._();

  static const light = ColorScheme(
    brightness: Brightness.light,

    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,

    secondary: AppColors.secondary,
    onSecondary: Colors.white,

    error: AppColors.error,
    onError: Colors.white,

    surface: AppColors.surface,
    onSurface: AppColors.onSurface,

    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,

    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.primary,

    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSurface,

    surfaceContainerHighest: AppColors.surfaceVariant,
  );
}

class AppColors {
  AppColors._();

  // ===========================================================================
  // BRAND TOKENS
  // ===========================================================================

  static const brand50 = Color(0xFFEFF6FF);
  static const brand100 = Color(0xFFDBEAFE);
  static const brand200 = Color(0xFFBFDBFE);
  static const brand300 = Color(0xFF93C5FD);
  static const brand400 = Color(0xFF60A5FA);
  static const brand500 = Color(0xFF3B82F6);
  static const brand600 = Color(0xFF2563EB);
  static const brand700 = Color(0xFF1D4ED8);
  static const brand800 = Color(0xFF1E40AF);
  static const brand900 = Color(0xFF0A2540);

  // ===========================================================================
  // NEUTRAL TOKENS
  // ===========================================================================

  static const gray50 = Color(0xFFF8FAFC);
  static const gray100 = Color(0xFFF1F5F9);
  static const gray200 = Color(0xFFE2E8F0);
  static const gray300 = Color(0xFFCBD5E1);
  static const gray400 = Color(0xFF94A3B8);
  static const gray500 = Color(0xFF64748B);
  static const gray600 = Color(0xFF475569);
  static const gray700 = Color(0xFF334155);
  static const gray800 = Color(0xFF1E293B);
  static const gray900 = Color(0xFF0F172A);

  // ===========================================================================
  // STATUS TOKENS
  // ===========================================================================

  static const success = Color(0xFF22C55E);
  static const successContainer = Color(0xFFDCFCE7);

  static const warning = Color(0xFFF59E0B);
  static const warningContainer = Color(0xFFFEF3C7);

  static const error = Color(0xFFEF4444);
  static const errorContainer = Color(0xFFFEE2E2);

  static const info = Color(0xFF3B82F6);
  static const infoContainer = Color(0xFFDBEAFE);

  // ===========================================================================
  // SEMANTIC COLORS (USE THESE IN UI)
  // ===========================================================================

  // Brand
  static const primary = brand900;
  static const primaryContainer = brand100;
  static const onPrimary = Colors.white;

  static const secondary = gray600;
  static const secondaryContainer = gray200;

  // Backgrounds
  static const background = gray50;

  static const surface = Colors.white;
  static const surfaceContainer = gray100;
  static const surfaceVariant = gray200;

  // Text
  static const onSurface = gray900;
  static const onSurfaceVariant = gray500;

  // Borders
  static const outline = gray300;
  static const outlineVariant = gray200;

  // Interactive States
  static const hover = gray100;
  static const pressed = gray200;
  static const disabled = gray300;
}
