import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';

class IntelPhoneField extends StatelessWidget {
  const IntelPhoneField({
    super.key,
    required this.phoneController,
    required this.darkTheme,
  });

  final TextEditingController phoneController;
  final bool darkTheme;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
        disableLengthCheck: true,
        initialCountryCode: "EG",
        initialValue: "+20",
        controller: phoneController,
        dropdownTextStyle: AppStyles.styleSemiBold16(darkTheme),
        dropdownIcon: Icon(Icons.arrow_drop_down,
            color: darkTheme ? DarkColors.textSecondary : LightColors.textSecondary),
        showCountryFlag: false,
        style: AppStyles.styleSemiBold16(darkTheme),
        cursorWidth: 3,
        cursorColor: darkTheme ? DarkColors.textSecondary : LightColors.textSecondary,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          filled: true,
          hintStyle: AppStyles.styleSemiBold16(darkTheme),
          fillColor: darkTheme ? DarkColors.accent : LightColors.accent,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ));
  }
}
