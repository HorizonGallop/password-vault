import 'package:flutter/material.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';

class AppTheme {
  /// ✅ DARK THEME
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Cairo',

    /// ✅ Colors
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.primary,

    /// ✅ Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.darkBackground,
      surface: AppColors.darkCard,
      error: AppColors.error,
    ),

    /// ✅ AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Cairo',
        color: AppColors.darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    /// ✅ Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkInput,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.darkDivider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.darkDivider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColors.darkTextSecondary),
    ),

    /// ✅ Text Theme
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontFamily: 'Cairo',
        color: AppColors.darkTextPrimary,
        fontSize: 16,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Cairo',
        color: AppColors.darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    /// ✅ Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.buttonText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        elevation: 4,
        shadowColor: AppColors.shadowDark.withOpacity(0.4),
      ),
    ),

    /// ✅ Cards
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  /// ✅ LIGHT THEME
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Cairo',

    /// ✅ Colors
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.primary,

    /// ✅ Color Scheme
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.lightBackground,
      surface: AppColors.lightCard,
      error: AppColors.error,
    ),

    /// ✅ AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Cairo',
        color: AppColors.lightTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    /// ✅ Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightInput,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.lightDivider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.lightDivider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColors.lightTextSecondary),
    ),

    /// ✅ Text Theme
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontFamily: 'Cairo',
        color: AppColors.lightTextPrimary,
        fontSize: 16,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Cairo',
        color: AppColors.lightTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    /// ✅ Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.buttonText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        elevation: 2,
        shadowColor: AppColors.shadowLight,
      ),
    ),

    /// ✅ Cards
    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
