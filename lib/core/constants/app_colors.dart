import 'package:flutter/material.dart';

abstract final class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF00695C);
  static const Color secondary = Color(0xFF80CBC4);

  // Backgrounds
  static const Color surface = Color(0xFFF7F9FB);
  static const Color surfaceContainer = Color(0xFFFFFFFF);

  // Typography
  static const Color onSurface = Color(0xFF1A2B3C);
  static const Color onSurfaceVariant = Color(0xFF455A64);

  // Semantic
  static const Color success = Color(0xFF00BFA5);
  static const Color error = Color(0xFFD32F2F);

  // Borders
  static const Color border = Color(0xFFE3E8EC);

  // Disabled
  static const Color disabled = Color(0xFFB0BEC5);
}