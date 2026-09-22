import 'package:flutter/material.dart';

/// Central place for every color used in PIXCARA.
///
/// Keep the palette dark, minimal, and warm-gold accented.
/// If you need a new color, add it here instead of hardcoding
/// it inside a widget.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF0B0B0D);
  static const Color surface = Color(0xFF17171A);
  static const Color surfaceLight = Color(0xFF221F1C);
  static const Color divider = Color(0xFF2A2A2E);

  static const Color gold = Color(0xFFD8A657);
  static const Color goldMuted = Color(0xFFB68A4E);

  static const Color textPrimary = Color(0xFFF5F1EA);
  static const Color textSecondary = Color(0xFF9C9A97);
  static const Color textDisabled = Color(0xFF5A5A5D);
}
