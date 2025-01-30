import 'package:flutter/material.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';

class ProgressDialog extends StatelessWidget {
  const ProgressDialog({super.key, required this.message, required this.darkTheme});

  final String message;
  final bool darkTheme;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: darkTheme ? DarkColors.accent : LightColors.accent,
      child: Container(
        margin: const EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          color: darkTheme ? DarkColors.accent : LightColors.accent,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          children: [
            SizedBox(width: 6),
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
            SizedBox(width: 26),
            Text(
              message,
              style: AppStyles.styleSemiBold12(darkTheme),
            )
          ],
        ),
      ),
    );
  }
}
