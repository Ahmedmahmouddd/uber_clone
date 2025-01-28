import 'package:flutter/material.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';

showCustomSnackBar(BuildContext context, String message, bool darkTheme) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: AppStyles.styleSnackbar()),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      backgroundColor: LightColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
  );
}
