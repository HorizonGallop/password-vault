import 'package:flutter/material.dart';

/// Centralized color management for the app.
/// Modify colors here without touching UI code.
abstract final class AppColors {
  const AppColors._();

  // Base Colors
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color transparent = Colors.transparent;

  // Brand Colors
  static const Color primary = Color(0xFF3B82F6); // Blue (Buttons, highlights)
  static const Color secondary = Color(0xFF60A5FA); // Light Blue
  static const Color dark = Color(0xFF121212); // Dark background

  // Neutral Colors
  static const Color gray = Color(0xFF9CA3AF);
  static const Color lightGray = Color(0xFFD1D5DB);

  // Feedback Colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color error = Color(0xFFEF4444); // Red
  static const Color warning = Color(0xFFF59E0B); // Yellow

  // UI Specific
  static const Color scaffoldBackground = dark;
  static const Color appBarBackground = dark;
  static const Color buttonBackground = primary;
  static const Color buttonText = white;
  static const Color inputBackground = Color(0xFF1F2937);
  static const Color inputBorder = gray;
  static const Color inputText = white;
  static const Color hintText = gray;
  static const Color dividerColor = Color(0xFF2D3748);
  static const Color cardBackground = Color(0xFF1E293B);
  static const Color overlayColor = Color(0x1FFFFFFF); // 12% White
  static const Color disabledColor = Color(0xFF4B5563);

  // Text Colors
  static const Color titleText = white;
  static const Color bodyText = gray;
  static const Color linkText = primary;
}
