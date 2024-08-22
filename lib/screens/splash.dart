import 'dart:async';

import 'package:eat_today/screens/home.dart';
import 'package:eat_today/screens/login.dart';
import 'package:eat_today/screens/onboarding.dart'; // Assuming you have an OnBoarding screen
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('showLogin', false);
    bool showLogin =
        prefs.getBool('showLogin') ?? false; // Default to true if null
    bool isLogin = prefs.getBool('active') ?? false; // Default to true if null
    print(isLogin);

    // Navigate after a delay
    Timer(Duration(seconds: 3), () {
      if (showLogin && !isLogin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else if (isLogin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => OnBoarding()), // Navigate to OnBoarding
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  'assets/images/logo.jpeg',
                  height: MediaQuery.of(context).size.width * 0.5,
                  width: MediaQuery.of(context).size.width * 0.5,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
