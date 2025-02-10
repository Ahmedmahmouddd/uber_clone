 import 'package:flutter/material.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';
import 'package:uber_clone/presentation/auth/widgets/auth_text_field.dart';

Future<void> editDialogAlert(
      {required BuildContext context,
      required String stringInput,
      editedString,
      required bool darkTheme,
      required TextEditingController controller,
      required Function() cancelButton,
      required Function() updateButton}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update $editedString", style: AppStyles.styleSemiBold14(darkTheme)),
          content: AuthTextFormField(darkTheme: darkTheme, controller: controller),
          actions: [
            TextButton(
                onPressed: cancelButton, child: Text("Cancel", style: AppStyles.styleSemiBold12(darkTheme))),
            TextButton(
                onPressed: updateButton, child: Text("Update", style: AppStyles.styleSemiBold12(darkTheme))),
          ],
        );
      },
    );
  }
