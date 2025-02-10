import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_clone/common/theme_provider/app_colors.dart';
import 'package:uber_clone/common/theme_provider/app_styles.dart';
import 'package:uber_clone/presentation/auth/bloc/sign_in_cubit/sign_in_cubit.dart';
import 'package:uber_clone/presentation/auth/screens/signup.dart';
import 'package:uber_clone/presentation/auth/widgets/auth_button.dart';
import 'package:uber_clone/presentation/auth/widgets/auth_text_field.dart';
import 'package:uber_clone/presentation/auth/widgets/custom_snackbar.dart';
import 'package:uber_clone/presentation/home/screens/home.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  static final signinkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool passwordVisible = true;
  bool confirmPasswordVisible = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return BlocProvider(
      create: (context) => SignInCubit(),
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
                          // mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AuthTextFormField(
                              darkTheme: darkTheme,
                              controller: emailController,
                              hint: "Email",
                              icon: Icons.email_rounded,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a vaild email";
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
                                  return "Please enter an password";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 30),
                            BlocConsumer<SignInCubit, SignInState>(
                              listener: (context, state) {
                                if (state is SignInSuccess) {
                                  showCustomSnackBar(context, "Sign in successful", darkTheme);
                                  Navigator.pushReplacement(
                                      context, MaterialPageRoute(builder: (context) => Home()));
                                } else if (state is SignInFailure) {
                                  showCustomSnackBar(context, state.errMessage, darkTheme);
                                }
                              },
                              builder: (context, state) {
                                final bool isLoading = state is SignInLoading;
                                return AuthButton(
                                  loading: isLoading,
                                  text: "Sign In",
                                  darkTheme: darkTheme,
                                  onPressed: () {
                                    if (signinkey.currentState!.validate()) {
                                      BlocProvider.of<SignInCubit>(context).signIn(
                                        email: emailController.text.trim(),
                                        password: passwordController.text.trim(),
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
