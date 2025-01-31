import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';
import 'package:uber_clone/presentation/auth/widgets/auth_text_field.dart';
import 'package:uber_clone/presentation/auth/widgets/custom_snackbar.dart';
import 'package:uber_clone/presentation/home/widgets/edit_user_info_row.dart';
import 'package:uber_clone/presentation/splash/bloc/auth_gate_cubit/auth_gate_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameTextEditingController = TextEditingController();
  final phoneNumberTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();
  DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users");

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

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LightColors.primary,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: darkTheme ? DarkColors.accent : LightColors.accent,
            )),
        title: Text("Edit Profile", style: AppStyles.styleSemiBold16Reverse(darkTheme)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: darkTheme ? DarkColors.textSecondary : LightColors.textSecondary),
                child: Icon(
                  Icons.person_add_alt,
                  size: 42,
                  color: darkTheme ? DarkColors.background : LightColors.background,
                ),
              ),
            ),
            SizedBox(height: 20),
            EditUserInfoRow(
              title: context.read<AuthGateCubit>().userModelCurrentInfo!.name!,
              darkTheme: darkTheme,
              onPressed: () => editDialogAlert(
                context: context,
                stringInput: "Name",
                editedString: "Name",
                darkTheme: darkTheme,
                controller: nameTextEditingController,
                cancelButton: () {
                  Navigator.pop(context);
                },
                updateButton: () {
                  userRef
                      .child(FirebaseAuth.instance.currentUser!.uid)
                      .update({"name": nameTextEditingController.text}).then(
                          (value) => showCustomSnackBar(context, "Name has been updated", darkTheme));
                  nameTextEditingController.clear();
                  Navigator.pop(context);
                },
              ),
            ),
            EditUserInfoRow(
              title: context.read<AuthGateCubit>().userModelCurrentInfo!.address!,
              darkTheme: darkTheme,
              onPressed: () => editDialogAlert(
                context: context,
                stringInput: "Address",
                editedString: "Address",
                darkTheme: darkTheme,
                controller: addressTextEditingController,
                cancelButton: () {
                  addressTextEditingController.clear();
                  Navigator.pop(context);
                },
                updateButton: () {
                  Navigator.pop(context);
                },
              ),
            ),
            EditUserInfoRow(
              title: context.read<AuthGateCubit>().userModelCurrentInfo!.phoneNumber!,
              darkTheme: darkTheme,
              onPressed: () => editDialogAlert(
                context: context,
                stringInput: "Phone number",
                editedString: "Phone number",
                darkTheme: darkTheme,
                controller: phoneNumberTextEditingController,
                cancelButton: () {
                  phoneNumberTextEditingController.clear();
                  Navigator.pop(context);
                },
                updateButton: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: 8),
            Row(children: [
              Text(
                context.read<AuthGateCubit>().userModelCurrentInfo!.email!,
                style: AppStyles.styleSemiBold16(darkTheme),
              )
            ])
          ],
        ),
      ),
    );
  }
}
