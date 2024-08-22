import 'package:eat_today/cubit/main_cubit.dart';
import 'package:eat_today/screens/login.dart';
import 'package:eat_today/screens/onboarding.dart';
import 'package:eat_today/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {

  runApp(
    BlocProvider(
      create: (context) => MainCubit()
        ..initSql()
        ..getData(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
