import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone/common/info_handler/app_info.dart';
import 'package:uber_clone/common/theme_provider/theme_provider.dart';
import 'package:uber_clone/firebase_options.dart';
import 'package:uber_clone/presentation/home/bloc/pickup&dropoff_location_cubit/pickup&dropoff_location_cubit.dart';
import 'package:uber_clone/presentation/splash/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const TaxiApp());
}

class TaxiApp extends StatelessWidget {
  const TaxiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PickUpAndDropOffLocationCubit(),
      child: ChangeNotifierProvider(
          create: (context) => AppInfo(),
          child: MaterialApp(
            themeMode: ThemeMode.system,
            theme: lightTheme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,
            home: AuthGate(),
          )),
    );
  }
}
