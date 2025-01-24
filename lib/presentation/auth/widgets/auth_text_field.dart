import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';

class AuthTextFormField extends StatelessWidget {
  const AuthTextFormField({
    super.key,
    required this.darkTheme,
    required this.nameController,
    required this.hint,
    required this.icon,
    this.validator,
    this.suffixIcon,
    this.obsecure = false,
  });

  final bool darkTheme;
  final IconButton? suffixIcon;
  final TextEditingController nameController;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final bool? obsecure;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          errorStyle: TextStyle(
            color: darkTheme ? const Color.fromARGB(180, 250, 251, 255) : LightColors.accent,
            fontSize: 12, // Custom font size
            fontWeight: FontWeight.w600, // Custom weight
          ),
        ),
      ),
      child: TextFormField(
        obscuringCharacter: "*",
        obscureText: obsecure!,
        style: AppStyles.styleSemiBold16(darkTheme),
        cursorWidth: 3,
        cursorColor: darkTheme ? DarkColors.accent : LightColors.accent,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: [LengthLimitingTextInputFormatter(50)],
        decoration: InputDecoration(
          filled: true,
          hintText: hint,
          hintStyle: AppStyles.styleSemiBold16(darkTheme),
          suffixIcon: suffixIcon,
          fillColor:
              darkTheme ? const Color.fromARGB(136, 250, 251, 255) : const Color.fromARGB(216, 250, 251, 255),
          prefixIcon: Icon(icon, color: darkTheme ? DarkColors.accent : LightColors.accent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        validator: validator,
        controller: nameController,
      ),
    );
  }
}
