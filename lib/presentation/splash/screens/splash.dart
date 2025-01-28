// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/presentation/auth/models/user_model.dart';
import 'package:uber_clone/presentation/auth/screens/signup.dart';
import 'package:uber_clone/presentation/home/screens/home.dart';

UserModel? userModelCurrentInfo;

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<Widget> readCurrentOnlineInfo() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {
        // Load current user info if authenticated
        DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users").child(currentUser.uid);
        DataSnapshot snap = await userRef.once().then((event) => event.snapshot);
        if (snap.value != null) {
          userModelCurrentInfo = UserModel.fromsnapshot(snap);
        }
      } catch (e) {
        debugPrint("Error fetching user data: $e");
      }
      return Home();
    }
    return SignUp();
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return FutureBuilder<Widget>(
      future: readCurrentOnlineInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: darkTheme ? DarkColors.accent : LightColors.background,
            body: SizedBox(),
          );
        }

        if (snapshot.hasData) {
          return snapshot.data!;
        }

        return SignUp();
      },
    );
  }
}
