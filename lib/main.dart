import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:uber_clone/common/theme_provider/theme_provider.dart';
import 'package:uber_clone/firebase_options.dart';

import 'package:uber_clone/presentation/auth/screens/signup.dart';
import 'package:uber_clone/presentation/home/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure the Flutter framework is properly initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const TaxiApp(),
  );
}

class TaxiApp extends StatelessWidget {
  const TaxiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      themeMode: ThemeMode.system,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.lightTheme,
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null ? SignUp() : Home(),
    );
  }
}
