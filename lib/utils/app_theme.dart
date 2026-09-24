import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_sizes.dart';

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

    // Botones: las pantallas heredan estos estilos, no los repiten
    elevatedButtonTheme: ElevatedButtonThemeData(style: _botonPrincipal),
    filledButtonTheme: FilledButtonThemeData(style: _botonPrincipal),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.grey,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),

    // Campos de texto
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.greyLight,
      hintStyle: const TextStyle(
        color: AppColors.borderVariant,
        fontSize: AppSizes.textSm,
      ),
      prefixIconColor: AppColors.grey,
      suffixIconColor: AppColors.grey,
      contentPadding: const EdgeInsets.symmetric(vertical: AppSizes.md),
      border: _bordeCampo(AppColors.border),
      enabledBorder: _bordeCampo(AppColors.border),
      focusedBorder: _bordeCampo(AppColors.primary, ancho: 1.5),
      errorBorder: _bordeCampo(AppColors.error),
      focusedErrorBorder: _bordeCampo(AppColors.error, ancho: 1.5),
    ),

    // Mensajes (SnackBar) y diálogos
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
    ),

    // Textos
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: AppSizes.textXxl,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryDark,
      ),
      headlineSmall: TextStyle(
        fontSize: AppSizes.textXl,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryDark,
      ),
      titleMedium: TextStyle(
        fontSize: AppSizes.textLg,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
      bodyMedium: TextStyle(
        fontSize: AppSizes.textSm,
        color: AppColors.grey,
        height: 1.4,
      ),
      bodySmall: TextStyle(fontSize: AppSizes.textXs, color: AppColors.grey),
      labelMedium: TextStyle(
        fontSize: AppSizes.textLabel,
        fontWeight: FontWeight.w600,
        color: AppColors.grey,
      ),
    ),
  );

  static OutlineInputBorder _bordeCampo(Color color, {double ancho = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      borderSide: BorderSide(color: color, width: ancho),
    );
  }

  static final ButtonStyle _botonPrincipal = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
    ),
    elevation: 0,
    textStyle: const TextStyle(
      fontSize: AppSizes.textMd,
      fontWeight: FontWeight.bold,
    ),
  );
}
