import 'package:email_validator/email_validator.dart';
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
  static final emailController = TextEditingController();
  static final passwordController = TextEditingController();
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
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image:
                        AssetImage(darkTheme ? "assets/images/citynight.jpg" : "assets/images/cityday.jpg"),
                    fit: BoxFit.cover),
              ),
              child: ListView(
                padding: EdgeInsets.all(0),
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 80.0),
                        child: Text("Sign In", style: AppStyles.pageHeader25(darkTheme)),
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
                                nameController: emailController,
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
                              AuthTextFormField(
                                obsecure: passwordVisible,
                                suffixIcon: passwordVisible
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            passwordVisible = !passwordVisible;
                                          });
                                        },
                                        icon: Icon(Icons.visibility,
                                            color: darkTheme ? DarkColors.accent : LightColors.accent),
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          setState(() {
                                            passwordVisible = !passwordVisible;
                                          });
                                        },
                                        icon: Icon(Icons.visibility_off_outlined,
                                            color: darkTheme ? DarkColors.accent : LightColors.accent),
                                      ),
                                darkTheme: darkTheme,
                                nameController: passwordController,
                                hint: "Password",
                                icon: Icons.password_rounded,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter an password";
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
                              SizedBox(height: 30),
                              BlocConsumer<SignInCubit, SignInState>(
                                listener: (context, state) {
                                  if (state is SignInSuccess) {
                                    showCustomSnackBar(context, "Sign in successful", darkTheme);
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                      return const Home();
                                    }));
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
                                          email: emailController.text,
                                          password: passwordController.text,
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
                                  Text(
                                    r"Don't have an account? ",
                                    style: AppStyles.styleSemiBold16(darkTheme).copyWith(
                                        color: darkTheme ? DarkColors.primary : LightColors.accent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return const SignUp();
                                      }));
                                    },
                                    child: Text(
                                      "Sign up",
                                      style: AppStyles.styleSemiBold16(darkTheme).copyWith(
                                          color: darkTheme ? DarkColors.primary : LightColors.accent,
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              darkTheme ? DarkColors.primary : LightColors.accent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
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
          )),
    );
  }
}
