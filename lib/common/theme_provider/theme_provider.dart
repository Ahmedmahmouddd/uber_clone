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
    onPrimary: Colors.white,
    onSecondary: LightColors.textPrimary,
    onSurface: LightColors.textPrimary,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: LightColors.textPrimary, fontSize: 16),
    bodyMedium: TextStyle(color: LightColors.textSecondary, fontSize: 14),
    titleLarge: TextStyle(color: LightColors.textPrimary, fontSize: 18),
    labelSmall: TextStyle(color: LightColors.textSecondary, fontSize: 12),
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
    onPrimary: Colors.black,
    onSecondary: DarkColors.textPrimary,
    onSurface: DarkColors.textPrimary,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: DarkColors.textPrimary, fontSize: 16),
    bodyMedium: TextStyle(color: DarkColors.textSecondary, fontSize: 14),
    titleLarge: TextStyle(color: DarkColors.textPrimary, fontSize: 18),
    labelSmall: TextStyle(color: DarkColors.textSecondary, fontSize: 12),
  ),
);
