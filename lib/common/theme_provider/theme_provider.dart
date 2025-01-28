import 'package:flutter/material.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: LightColors.primary,
  scaffoldBackgroundColor: LightColors.background,
  colorScheme: const ColorScheme.light(
    primary: LightColors.primary,
    secondary: LightColors.accent,
    surface: LightColors.background,
    background: LightColors.background, // Adding background consistency
    onPrimary: Colors.white, // Text/icon color on primary (e.g., buttons)
    onSecondary: LightColors.textPrimary, // Text/icon color on accent
    onSurface: LightColors.textPrimary, // Text/icon color on surface
    onBackground: LightColors.textPrimary, // Text/icon color on background
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: LightColors.textPrimary, fontSize: 16), // Primary text
    bodyMedium: TextStyle(color: LightColors.textSecondary, fontSize: 14), // Secondary text
    titleLarge: TextStyle(color: LightColors.textPrimary, fontSize: 18), // Titles/headers
    labelSmall: TextStyle(color: LightColors.textSecondary, fontSize: 12), // Labels
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: DarkColors.primary,
  scaffoldBackgroundColor: DarkColors.background,
  colorScheme: const ColorScheme.dark(
    primary: DarkColors.primary,
    secondary: DarkColors.accent,
    surface: DarkColors.background,
    background: DarkColors.background, // Adding background consistency
    onPrimary: Colors.black, // Text/icon color on primary (e.g., buttons)
    onSecondary: DarkColors.textPrimary, // Text/icon color on accent
    onSurface: DarkColors.textPrimary, // Text/icon color on surface
    onBackground: DarkColors.textPrimary, // Text/icon color on background
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: DarkColors.textPrimary, fontSize: 16), // Primary text
    bodyMedium: TextStyle(color: DarkColors.textSecondary, fontSize: 14), // Secondary text
    titleLarge: TextStyle(color: DarkColors.textPrimary, fontSize: 18), // Titles/headers
    labelSmall: TextStyle(color: DarkColors.textSecondary, fontSize: 12), // Labels
  ),
);
