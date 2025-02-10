import 'package:flutter/material.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';

class AuthDropdownFormField extends StatelessWidget {
  const AuthDropdownFormField({
    super.key,
    required this.darkTheme,
    required this.items,
    this.validator,
    this.onChanged,
    this.value,
    required this.hint,
    required this.icon,
  });

  final bool darkTheme;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final String hint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(errorStyle: AppStyles.styleError12()),
      ),
      child: DropdownButtonFormField(
        items: items,
        hint: Text(hint, style: AppStyles.styleSemiBold16(darkTheme)),
        value: value,
        icon: Icon(Icons.keyboard_arrow_down_rounded,
            color: darkTheme ? DarkColors.background : LightColors.textSecondary),
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          hintStyle: AppStyles.styleSemiBold16(darkTheme),
          fillColor: darkTheme ? DarkColors.accent : LightColors.accent,
          prefixIcon: Icon(icon, color: darkTheme ? DarkColors.textSecondary : LightColors.textSecondary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
