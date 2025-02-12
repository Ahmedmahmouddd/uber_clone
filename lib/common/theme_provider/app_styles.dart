import 'package:flutter/material.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';

abstract class AppStyles {
  static TextStyle styleBold24(bool darkTheme) {
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: DarkColors.primary,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle styleBold20(bool darkTheme) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: darkTheme ? DarkColors.textPrimary : LightColors.textPrimary,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle styleSemiBold14(bool darkTheme) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      fontFamily: 'Poppins',
      color: darkTheme ? DarkColors.textPrimary : LightColors.textPrimary,
    );
  }

  static TextStyle styleSemiBold12Light() {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      fontFamily: 'Poppins',
      color: DarkColors.textPrimary,
    );
  }

  static TextStyle styleSemiBold16(bool darkTheme) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: 'Poppins',
      color: darkTheme ? DarkColors.textPrimary : LightColors.textPrimary,
    );
  }

  static TextStyle styleSemiBold18(bool darkTheme) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      fontFamily: 'Poppins',
      color: darkTheme ? DarkColors.textPrimary : LightColors.textPrimary,
    );
  }

  static TextStyle styleSemiBold16Reverse(bool darkTheme) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: 'Poppins',
      color: darkTheme ? DarkColors.accent : LightColors.accent,
    );
  }

  static TextStyle styleSnackbar() {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      fontFamily: 'Poppins',
      color: LightColors.background,
    );
  }

  static TextStyle styleError12() {
    return TextStyle(
      color: Colors.red,
      fontFamily: 'Poppins',
      fontSize: 12,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle styleBold18Reverse(bool darkTheme) {
    return TextStyle(
      fontSize: 18,
      color: darkTheme ? DarkColors.textPrimary : LightColors.white,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle styleBold16(bool darkTheme) {
    return TextStyle(
        color: darkTheme ? DarkColors.textSecondary : LightColors.textSecondary,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        fontSize: 16);
  }

  static TextStyle styleSemiBold12(bool darkTheme) {
    return TextStyle(
        color: darkTheme ? DarkColors.textPrimary : LightColors.textPrimary,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        fontSize: 12);
  }
}
