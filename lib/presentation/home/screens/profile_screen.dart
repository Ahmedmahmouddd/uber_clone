// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';
import 'package:uber_clone/presentation/auth/widgets/custom_snackbar.dart';
import 'package:uber_clone/presentation/home/bloc/save_current_user_info_cubit/save_current_user_info_cubit.dart';
import 'package:uber_clone/presentation/home/widgets/edit_dialog_alet.dart';
import 'package:uber_clone/presentation/home/widgets/edit_user_info_row.dart';

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
              title: context.read<LoadCurrentUserInfoCubit>().userModelCurrentInfo!.name!,
              darkTheme: darkTheme,
              onPressed: () => editDialogAlert(
                context: context,
                stringInput: "Name",
                editedString: "Name",
                darkTheme: darkTheme,
                controller: nameTextEditingController,
                cancelButton: () {
                  nameTextEditingController.clear();
                  Navigator.pop(context);
                },
                updateButton: () {
                  context.read<LoadCurrentUserInfoCubit>().userModelCurrentInfo!.name =
                      nameTextEditingController.text.trim();
                  userRef
                      .child(FirebaseAuth.instance.currentUser!.uid)
                      .update({"name": nameTextEditingController.text.trim()}).then(
                          (value) => showCustomSnackBar(context, "Name has been updated", darkTheme));
                  nameTextEditingController.clear();
                  Navigator.pop(context);
                },
              ),
            ),
            EditUserInfoRow(
              title: context.read<LoadCurrentUserInfoCubit>().userModelCurrentInfo!.address!,
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
                  context.read<LoadCurrentUserInfoCubit>().userModelCurrentInfo!.address =
                      addressTextEditingController.text.trim();
                  userRef
                      .child(FirebaseAuth.instance.currentUser!.uid)
                      .update({"address": addressTextEditingController.text.trim()}).then(
                          (value) => showCustomSnackBar(context, "Address has been updated", darkTheme));
                  addressTextEditingController.clear();
                  Navigator.pop(context);
                },
              ),
            ),
            EditUserInfoRow(
              title: context.read<LoadCurrentUserInfoCubit>().userModelCurrentInfo!.phoneNumber!,
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
                  context.read<LoadCurrentUserInfoCubit>().userModelCurrentInfo!.phoneNumber =
                      phoneNumberTextEditingController.text.trim();
                  userRef
                      .child(FirebaseAuth.instance.currentUser!.uid)
                      .update({"phone": phoneNumberTextEditingController.text.trim()}).then(
                          (value) => showCustomSnackBar(context, "Phone number has been updated", darkTheme));
                  phoneNumberTextEditingController.clear();
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: 8),
            Row(children: [
              Text(
                context.read<LoadCurrentUserInfoCubit>().userModelCurrentInfo!.email!,
                style: AppStyles.styleSemiBold16(darkTheme),
              )
            ])
          ],
        ),
      ),
    );
  }
}
