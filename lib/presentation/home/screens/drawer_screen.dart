import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';
import 'package:uber_clone/presentation/auth/screens/signin.dart';
import 'package:uber_clone/presentation/home/bloc/save_current_user_info_cubit/save_current_user_info_cubit.dart';
import 'package:uber_clone/presentation/home/screens/profile_screen.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key, required this.darkTheme});
  final bool darkTheme;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 50, 30, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            SizedBox(height: 12),
            Center(
              child: Text(
                  context.read<LoadCurrentUserInfoCubit>().userModelCurrentInfo!.name![0].toUpperCase() +
                      context.read<LoadCurrentUserInfoCubit>().userModelCurrentInfo!.name!.substring(1),
                  style: AppStyles.styleBold20(darkTheme),
                  textAlign: TextAlign.center),
            ),
            SizedBox(height: 4),
            Center(
              child: GestureDetector(
                  onTap: () =>
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen())),
                  child: Text("Edit Profile",
                      style: AppStyles.styleBold18Reverse(darkTheme).copyWith(color: LightColors.primary),
                      textAlign: TextAlign.center)),
            ),
            SizedBox(height: 30),
            Text("Your Trips", style: AppStyles.styleSemiBold16(darkTheme)),
            SizedBox(height: 10),
            Text("Payments", style: AppStyles.styleSemiBold16(darkTheme)),
            SizedBox(height: 10),
            Text("Notifications", style: AppStyles.styleSemiBold16(darkTheme)),
            SizedBox(height: 10),
            Text("Promos", style: AppStyles.styleSemiBold16(darkTheme)),
            SizedBox(height: 10),
            Text("Help", style: AppStyles.styleSemiBold16(darkTheme)),
            SizedBox(height: 10),
            Text("Free Trips", style: AppStyles.styleSemiBold16(darkTheme)),
            SizedBox(height: 10),
            Spacer(),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (context) => SignIn()), (route) => false);
              },
              child:
                  Text("Sign out", style: AppStyles.styleSemiBold16(darkTheme).copyWith(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
