import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme(
      brightness: Brightness.light,

      // Colores principales
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.secondary,
      onSecondary: AppColors.white,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.white,

      // Fondos y superficies
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,

      // Estados
      error: AppColors.error,
      onError: AppColors.white,

      // Bordes
      outline: AppColors.border,
      outlineVariant: AppColors.borderVariant,

      // Variantes
      primaryContainer: AppColors.primary,
      onPrimaryContainer: AppColors.white,
      secondaryContainer: AppColors.secondary,
      onSecondaryContainer: AppColors.white,
      tertiaryContainer: AppColors.tertiary,
      onTertiaryContainer: AppColors.white,
      errorContainer: AppColors.error,
      onErrorContainer: AppColors.white,

      // Inversos
      inverseSurface: AppColors.textPrimary,
      onInverseSurface: AppColors.white,
      inversePrimary: AppColors.primary,
    ),

    scaffoldBackgroundColor: AppColors.background,
  );
}
