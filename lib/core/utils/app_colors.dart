import 'package:flutter/material.dart';

/// Centralized color management for the app.
/// Supports Dark & Light themes with dedicated colors.
abstract final class AppColors {
  const AppColors._();

  // ✅ Base Colors
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color transparent = Colors.transparent;

  // ✅ Brand Colors
  static const Color primary = Color(0xFF3B82F6); // Blue
  static const Color secondary = Color(0xFF60A5FA); // Light Blue
  static const Color accent = Color(0xFF2563EB); // Darker Blue Accent

  // ✅ Neutral
  static const Color gray = Color(0xFF9CA3AF);
  static const Color lightGray = Color(0xFFD1D5DB);
  static const Color darkGray = Color(0xFF1F2937);

  // ✅ Feedback
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // ✅ Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkInput = Color(0xFF1F2937);
  static const Color darkDivider = Color(0xFF2D3748);

  // ✅ Light Theme Colors
  static const Color lightBackground = Color(0xFFF9FAFB);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightInput = Color(0xFFF3F4F6);
  static const Color lightDivider = Color(0xFFE5E7EB);

  // ✅ Buttons
  static const Color buttonBackground = primary;
  static const Color buttonText = white;
  static const Color disabledButton = Color(0xFF9CA3AF);

  // ✅ Text Colors
  static const Color darkTextPrimary = white;
  static const Color darkTextSecondary = gray;
  static const Color lightTextPrimary = black;
  static const Color lightTextSecondary = Color(0xFF4B5563);

  // ✅ Shadows
  static const Color shadowDark = Color(0xFF000000);
  static const Color shadowLight = Color(0x1F000000); // 12% black

  // ✅ Overlay
  static const Color overlay = Color(0x1FFFFFFF); // 12% White
}
