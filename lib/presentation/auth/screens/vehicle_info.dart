import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';
import 'package:uber_clone/presentation/auth/bloc/sign_up_cubit/sign_up_cubit.dart';
import 'package:uber_clone/presentation/auth/screens/signup.dart';
import 'package:uber_clone/presentation/auth/widgets/auth_button.dart';
import 'package:uber_clone/presentation/auth/widgets/auth_text_field.dart';
import 'package:uber_clone/presentation/auth/widgets/custom_snackbar.dart';
import 'package:uber_clone/presentation/auth/widgets/dropdown_form_field.dart';
import 'package:uber_clone/presentation/home/screens/driver_home.dart';

class VehicleInfo extends StatefulWidget {
  const VehicleInfo(
      {super.key,
      required this.name,
      required this.phone,
      required this.email,
      required this.address,
      required this.password,
      required this.confirmPassword,
      required this.userRole});

  final String name;
  final String phone;
  final String email;
  final String address;
  final String password;
  final String confirmPassword;
  final String userRole;

  @override
  State<VehicleInfo> createState() => _VehicleInfoState();
}

class _VehicleInfoState extends State<VehicleInfo> {
  static final signinkey = GlobalKey<FormState>();
  final vehicleModelController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final vehicleColorController = TextEditingController();
  final vehicleTypeController = TextEditingController();

  bool passwordVisible = true;
  bool confirmPasswordVisible = true;

  @override
  void dispose() {
    vehicleModelController.dispose();
    vehicleNumberController.dispose();
    vehicleColorController.dispose();
    vehicleTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: darkTheme ? DarkColors.background : LightColors.white,
            body: ListView(
              padding: EdgeInsets.all(0),
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 80.0),
                      child: Text("Sign In", style: AppStyles.styleBold24(darkTheme)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                      child: Form(
                        key: signinkey,
                        child: Column(
                          children: [
                            AuthTextFormField(
                              darkTheme: darkTheme,
                              controller: vehicleModelController,
                              hint: "Vehicle Model",
                              icon: Icons.no_crash_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a valid model";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            AuthTextFormField(
                              darkTheme: darkTheme,
                              controller: vehicleNumberController,
                              hint: "Vehicle Number",
                              icon: Icons.car_rental_rounded,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a valid number";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            AuthTextFormField(
                              darkTheme: darkTheme,
                              controller: vehicleColorController,
                              hint: "Vehicle Color",
                              icon: Icons.format_color_fill_rounded,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a valid color";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            AuthDropdownFormField(
                              items: [
                                DropdownMenuItem(
                                    value: 'Car',
                                    child: Text('Car', style: AppStyles.styleSemiBold16(darkTheme))),
                                DropdownMenuItem(
                                    value: 'Bike',
                                    child: Text('Bike', style: AppStyles.styleSemiBold16(darkTheme))),
                              ],
                              hint: "Vehicle Type",
                              icon: Icons.minor_crash_outlined,
                              darkTheme: darkTheme,
                              onChanged: (value) {
                                vehicleTypeController.text = value.toString();
                                log(vehicleTypeController.text);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please select a vehicle type";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            SizedBox(height: 30),
                            BlocConsumer<SignUpCubit, SignUpState>(
                              listener: (context, state) {
                                if (state is SignUpSuccess) {
                                  showCustomSnackBar(context, "Sign up successful", darkTheme);
                                  Navigator.pushReplacement(
                                      context, MaterialPageRoute(builder: (context) => DriverHome()));
                                } else if (state is SignUpFailure) {
                                  showCustomSnackBar(context, state.errMessage, darkTheme);
                                }
                              },
                              builder: (context, state) {
                                final bool isLoading = state is SignUpLoading;
                                return AuthButton(
                                  loading: isLoading,
                                  text: "Sign In",
                                  darkTheme: darkTheme,
                                  onPressed: () {
                                    if (signinkey.currentState!.validate()) {
                                      BlocProvider.of<SignUpCubit>(context).signUp(
                                        email: widget.email,
                                        password: widget.password,
                                        userName: widget.name,
                                        address: widget.address,
                                        phone: widget.phone,
                                        role: widget.userRole,
                                        vehicleModel: vehicleModelController.text.trim(),
                                        vehicleNumber: vehicleNumberController.text.trim(),
                                        vehicleColor: vehicleColorController.text.trim(),
                                        vehicleType: vehicleTypeController.text.trim(),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(r"Don't have an account? ", style: AppStyles.styleBold16(darkTheme)),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                      return const SignUp();
                                    }));
                                  },
                                  child: Text("Sign up",
                                      style: AppStyles.styleBold16(darkTheme)
                                          .copyWith(color: LightColors.primary)
                                          .copyWith(
                                              decoration: TextDecoration.underline,
                                              decorationColor: LightColors.primary)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
