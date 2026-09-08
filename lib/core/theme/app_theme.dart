import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract class AppTheme {
  const AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      primary: isDark ? AppColors.primaryDark : AppColors.primary,
      surface: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      error: AppColors.error,
    );

    final Color background =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final Color onSurface =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    final Color border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: AppTypography.fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.headlineMedium.copyWith(
          color: onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surface,
        selectedColor: scheme.primary,
        labelStyle: AppTypography.titleSmall.copyWith(color: onSurface),
        secondaryLabelStyle:
            AppTypography.titleSmall.copyWith(color: scheme.onPrimary),
        side: BorderSide(color: border),
        shape: const StadiumBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primary.withValues(alpha: 0.15),
        elevation: 0,
        height: 64,
      ),
      textTheme: TextTheme(
        headlineLarge: AppTypography.headlineLarge.copyWith(color: onSurface),
        headlineMedium:
            AppTypography.headlineMedium.copyWith(color: onSurface),
        titleMedium: AppTypography.titleMedium.copyWith(color: onSurface),
        titleSmall: AppTypography.titleSmall.copyWith(color: onSurface),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: onSurface),
        bodySmall: AppTypography.bodySmall.copyWith(
          color: isDark
              ? AppColors.darkOnSurfaceMuted
              : AppColors.lightOnSurfaceMuted,
        ),
        labelSmall: AppTypography.caption.copyWith(color: onSurface),
      ),
      dividerColor: border,
    );
  }
}
