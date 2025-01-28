import 'package:flutter/material.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';

showCustomSnackBar(BuildContext context, String message, bool darkTheme) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style:
            AppStyles.styleSemiBold16(darkTheme),
      ),
      behavior: SnackBarBehavior.floating, // Makes the SnackBar float
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12), // Adds margin around the SnackBar
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2), // Adds rounded corners
      ),
      backgroundColor:
          darkTheme ? DarkColors.accent : LightColors.accent, // Customize the color if needed
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Adds padding inside the SnackBar
    ),
  );
}
