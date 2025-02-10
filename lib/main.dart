import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uber_clone/common/theme_provider/theme_provider.dart';
import 'package:uber_clone/firebase_options.dart';
import 'package:uber_clone/presentation/home/bloc/drop_off_cubit/drop_off_cubit.dart';
import 'package:uber_clone/presentation/home/bloc/pickup&dropoff_location_cubit/pickup_location_cubit.dart';
import 'package:uber_clone/presentation/splash/bloc/auth_gate_cubit/auth_gate_cubit.dart';
import 'package:uber_clone/presentation/splash/screens/splash.dart';
import 'package:uber_clone/presentation/home/bloc/save_current_user_info_cubit/save_current_user_info_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const TaxiApp());
}

class TaxiApp extends StatelessWidget {
  const TaxiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PickUpLocationCubit()),
        BlocProvider(create: (context) => DropOffLocationCubit()),
        BlocProvider(create: (context) => AuthGateCubit()..chackAuthState()),
        BlocProvider(create: (conntext) => LoadCurrentUserInfoCubit()),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.system,
        theme: lightTheme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        home: AuthGate(),
      ),
    );
  }
}
