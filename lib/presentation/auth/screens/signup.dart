import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';
import 'package:uber_clone/presentation/auth/bloc/sign_up_cubit/sign_up_cubit.dart';
import 'package:uber_clone/presentation/auth/screens/signin.dart';
import 'package:uber_clone/presentation/auth/screens/vehicle_info.dart';
import 'package:uber_clone/presentation/auth/widgets/auth_button.dart';
import 'package:uber_clone/presentation/auth/widgets/auth_text_field.dart';
import 'package:uber_clone/presentation/auth/widgets/custom_snackbar.dart';
import 'package:uber_clone/presentation/auth/widgets/dropdown_form_field.dart';
import 'package:uber_clone/presentation/auth/widgets/intl_phone_field.dart';
import 'package:uber_clone/presentation/rider_home/screens/home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final signupKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final userRoleController = TextEditingController();

  bool passwordVisible = true;
  bool confirmPasswordVisible = true;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                      child: Text("Sign Up", style: AppStyles.styleBold24(darkTheme)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                      child: Form(
                        key: signupKey,
                        child: Column(
                          children: [
                            AuthTextFormField(
                              darkTheme: darkTheme,
                              controller: nameController,
                              hint: "Name",
                              icon: Icons.person,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a name";
                                }
                                if (value.length < 2) {
                                  return "Name must be at least 2 characters long";
                                }
                                if (value.length > 50) {
                                  return "Name must be less than 50 characters long";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            AuthDropdownFormField(
                              items: [
                                DropdownMenuItem(
                                    value: 'Rider',
                                    child: Text('Rider', style: AppStyles.styleSemiBold16(darkTheme))),
                                DropdownMenuItem(
                                    value: 'Driver',
                                    child: Text('Driver', style: AppStyles.styleSemiBold16(darkTheme))),
                              ],
                              hint: "Select Role",
                              icon: Icons.person,
                              darkTheme: darkTheme,
                              onChanged: (value) {
                                setState(() => userRoleController.text = value.toString());
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please select a role";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            AuthTextFormField(
                              darkTheme: darkTheme,
                              controller: emailController,
                              hint: "Email",
                              icon: Icons.email_rounded,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a name";
                                } else {
                                  if (!EmailValidator.validate(value)) {
                                    return "Please enter a valid email";
                                  }
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            IntelPhoneField(phoneController: phoneController, darkTheme: darkTheme),
                            SizedBox(height: 10),
                            AuthTextFormField(
                              darkTheme: darkTheme,
                              controller: addressController,
                              hint: "Address",
                              icon: Icons.location_city_rounded,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter an address";
                                }
                                if (value.length < 10) {
                                  return "Adress must be at least 10 characters long";
                                }
                                if (value.length > 100) {
                                  return "Address must be less than 100 characters long";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            AuthTextFormField(
                              obsecure: passwordVisible,
                              suffixIcon: passwordVisible
                                  ? IconButton(
                                      focusColor:
                                          darkTheme ? DarkColors.background : LightColors.textSecondary,
                                      onPressed: () {
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                      },
                                      icon: Icon(Icons.visibility,
                                          color:
                                              darkTheme ? DarkColors.background : LightColors.textSecondary),
                                    )
                                  : IconButton(
                                      focusColor:
                                          darkTheme ? DarkColors.background : LightColors.textSecondary,
                                      onPressed: () {
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                      },
                                      icon: Icon(Icons.visibility_off_outlined,
                                          color:
                                              darkTheme ? DarkColors.background : LightColors.textSecondary),
                                    ),
                              darkTheme: darkTheme,
                              controller: passwordController,
                              hint: "Password",
                              icon: Icons.password_rounded,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a password";
                                }
                                if (value.length < 8) {
                                  return "Password must be at least 8 characters long";
                                }
                                if (value.length > 25) {
                                  return "Password must be less than 25 characters long";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            AuthTextFormField(
                              obsecure: confirmPasswordVisible,
                              suffixIcon: confirmPasswordVisible
                                  ? IconButton(
                                      focusColor:
                                          darkTheme ? DarkColors.background : LightColors.textSecondary,
                                      onPressed: () {
                                        setState(() {
                                          confirmPasswordVisible = !confirmPasswordVisible;
                                        });
                                      },
                                      icon: Icon(Icons.visibility,
                                          color:
                                              darkTheme ? DarkColors.background : LightColors.textSecondary),
                                    )
                                  : IconButton(
                                      focusColor:
                                          darkTheme ? DarkColors.background : LightColors.textSecondary,
                                      onPressed: () {
                                        setState(() {
                                          confirmPasswordVisible = !confirmPasswordVisible;
                                        });
                                      },
                                      icon: Icon(Icons.visibility_off_outlined,
                                          color:
                                              darkTheme ? DarkColors.background : LightColors.textSecondary),
                                    ),
                              darkTheme: darkTheme,
                              controller: confirmPasswordController,
                              hint: "Confirm Password",
                              icon: Icons.password_rounded,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please confirm your password";
                                }
                                if (value != passwordController.text) {
                                  return "Passwords are not matching";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 30),
                            BlocConsumer<SignUpCubit, SignUpState>(
                              listener: (context, state) {
                                if (state is SignUpSuccess) {
                                  showCustomSnackBar(context, "Sign up successful", darkTheme);
                                  Navigator.pushReplacement(
                                      context, MaterialPageRoute(builder: (context) => Home()));
                                } else if (state is SignUpFailure) {
                                  showCustomSnackBar(context, state.errMessage, darkTheme);
                                }
                              },
                              builder: (context, state) {
                                final bool isLoading = state is SignUpLoading;
                                return AuthButton(
                                  loading: isLoading,
                                  text: userRoleController.text == "Driver" ? "Continue" : "Sign Up",
                                  darkTheme: darkTheme,
                                  onPressed: () {
                                    if (signupKey.currentState!.validate()) {
                                      if (userRoleController.text == "Rider") {
                                        BlocProvider.of<SignUpCubit>(context).signUp(
                                          email: emailController.text.trim(),
                                          password: passwordController.text.trim(),
                                          userName: nameController.text.trim(),
                                          address: addressController.text.trim(),
                                          phone: phoneController.text.trim(),
                                          role: userRoleController.text.trim(),
                                        );
                                      } else if (userRoleController.text == "Driver") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => VehicleInfo(
                                                    name: nameController.text,
                                                    address: addressController.text,
                                                    phone: phoneController.text,
                                                    email: emailController.text,
                                                    password: passwordController.text,
                                                    confirmPassword: confirmPasswordController.text,
                                                    userRole: userRoleController.text)));
                                      }
                                    }
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already have an account? ", style: AppStyles.styleBold16(darkTheme)),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                      return const SignIn();
                                    }));
                                  },
                                  child: Text("Sign in",
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
          ),
        ));
  }
}
