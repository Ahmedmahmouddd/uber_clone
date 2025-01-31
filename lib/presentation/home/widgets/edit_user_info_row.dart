import 'package:flutter/material.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';

class EditUserInfoRow extends StatelessWidget {
  const EditUserInfoRow({super.key, required this.title, required this.darkTheme, this.onPressed});

  final bool darkTheme;
  final void Function()? onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppStyles.styleSemiBold16(darkTheme)),
        IconButton(
            onPressed: onPressed,
            icon: Icon(Icons.edit, color: darkTheme ? DarkColors.textPrimary : LightColors.textPrimary))
      ],
    );
  }
}
