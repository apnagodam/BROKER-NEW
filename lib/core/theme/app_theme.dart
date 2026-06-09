import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF386832);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryGreen,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: MaterialColor(primaryGreen.toARGB32(), {
        50: primaryGreen.withValues(alpha: 0.1),
        100: primaryGreen.withValues(alpha: 0.2),
        200: primaryGreen.withValues(alpha: 0.3),
        300: primaryGreen.withValues(alpha: 0.4),
        400: primaryGreen.withValues(alpha: 0.5),
        500: primaryGreen,
        600: primaryGreen.withValues(alpha: 0.7),
        700: primaryGreen.withValues(alpha: 0.8),
        800: primaryGreen.withValues(alpha: 0.9),
        900: primaryGreen.withValues(alpha: 1.0),
      }),
    ).copyWith(secondary: primaryGreen),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: primaryGreen,
    colorScheme: ColorScheme.dark().copyWith(
      primary: primaryGreen,
      secondary: primaryGreen,
    ),
  );
}
