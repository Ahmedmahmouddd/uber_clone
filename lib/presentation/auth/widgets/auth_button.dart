import 'package:flutter/material.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.onPressed,
    required this.darkTheme,
    required this.text,
    required this.loading,
  });

  final bool darkTheme;
  final void Function() onPressed;
  final String text;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        height: 50,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: LightColors.primary,
              overlayColor: LightColors.primary,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
            ),
            onPressed: onPressed,
            child: loading
                ? SizedBox(
                    width: 25,
                    height: 50,
                    child: CircularProgressIndicator(
                      color: darkTheme ? DarkColors.accent : LightColors.background,
                    ),
                  )
                : SizedBox(child: Text(text, style: AppStyles.styleBold18Reverse(darkTheme)))));
  }
}
