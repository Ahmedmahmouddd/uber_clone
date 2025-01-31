import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';

class AuthTextFormField extends StatelessWidget {
  const AuthTextFormField(
      {super.key,
      required this.darkTheme,
      this.controller,
      this.hint,
      this.icon,
      this.validator,
      this.suffixIcon,
      this.obsecure = false,
      this.onChanged});

  final bool darkTheme;
  final IconButton? suffixIcon;
  final TextEditingController? controller;
  final String? hint;
  final IconData? icon;
  final String? Function(String?)? validator;
  final bool? obsecure;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(errorStyle: AppStyles.styleError12()),
      ),
      child: TextFormField(
        
        onChanged: onChanged,
        obscuringCharacter: "*",
        obscureText: obsecure!,
        style: AppStyles.styleSemiBold16(darkTheme),
        cursorWidth: 3,
        cursorColor: darkTheme ? DarkColors.textSecondary : LightColors.textSecondary,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: [LengthLimitingTextInputFormatter(50)],
        decoration: InputDecoration(
          filled: true,
          hintText: hint,
          hintStyle: AppStyles.styleSemiBold16(darkTheme),
          suffixIcon: suffixIcon,
          fillColor: darkTheme ? DarkColors.accent : LightColors.accent,
          prefixIcon: icon == null
              ? null
              : Icon(icon, color: darkTheme ? DarkColors.textSecondary : LightColors.textSecondary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        validator: validator,
        controller: controller,
      ),
    );
  }
}
