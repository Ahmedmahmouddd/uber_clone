import 'package:flutter/material.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';

showCustomSnackBar(BuildContext context, String message, bool darkTheme) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style:
            TextStyle(fontWeight: FontWeight.w600, color: darkTheme ? DarkColors.accent : LightColors.accent),
      ),
      behavior: SnackBarBehavior.floating, // Makes the SnackBar float
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12), // Adds margin around the SnackBar
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2), // Adds rounded corners
      ),
      backgroundColor:
          darkTheme ? DarkColors.primary : LightColors.background, // Customize the color if needed
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Adds padding inside the SnackBar
    ),
  );
}
