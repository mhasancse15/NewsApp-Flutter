import 'package:flutter/material.dart';

/// Centralized color tokens. Widgets should reference these rather than
/// hardcoding hex values.
abstract class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFFD64545);
  static const Color primaryDark = Color(0xFFFF6B6B);

  static const Color lightBackground = Color(0xFFF7F7F9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF1A1A1D);
  static const Color lightOnSurfaceMuted = Color(0xFF6B6B72);
  static const Color lightBorder = Color(0xFFE7E7EA);

  static const Color darkBackground = Color(0xFF121214);
  static const Color darkSurface = Color(0xFF1D1D20);
  static const Color darkOnSurface = Color(0xFFF2F2F3);
  static const Color darkOnSurfaceMuted = Color(0xFFA0A0A6);
  static const Color darkBorder = Color(0xFF2C2C30);

  static const Color success = Color(0xFF2E9E5B);
  static const Color error = Color(0xFFE0483B);
  static const Color warning = Color(0xFFE0A93B);

  static const Map<String, Color> categoryAccents = {
    'business': Color(0xFF3B6FE0),
    'technology': Color(0xFF7B3BE0),
    'sports': Color(0xFF2E9E5B),
    'health': Color(0xFFE0483B),
    'science': Color(0xFF3BC0E0),
    'entertainment': Color(0xFFE0913B),
    'general': Color(0xFFD64545),
  };

  static Color categoryAccent(String category) =>
      categoryAccents[category.toLowerCase()] ?? primary;
}
