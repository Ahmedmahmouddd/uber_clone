// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/presentation/auth/screens/signup.dart';
import 'package:uber_clone/presentation/home/screens/driver_home.dart';
import 'package:uber_clone/presentation/home/screens/home.dart';
import 'package:uber_clone/presentation/splash/bloc/auth_gate_cubit/auth_gate_cubit.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return BlocBuilder<AuthGateCubit, AuthGateState>(
      builder: (context, state) {
        if (state is AuthGateInitial) {
          return Scaffold(backgroundColor: darkTheme ? DarkColors.background : LightColors.background);
        } else if (state is AuthGateAuthenticatedAsRider) {
          return Home();
        } else if (state is AuthGateAuthenticatedAsDriver) {
          return DriverHome();
        } 
        else if (state is AuthGateUnAuthenticated) {
          return SignUp();
        } else if (state is AuthGateFailure) {
          return Scaffold(body: Center(child: Text(state.errorMessage)));
        }
        return Scaffold(body: Text("Unexpected state occurred"));
      },
    );
  }
}
