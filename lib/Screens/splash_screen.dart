import 'dart:async';

import 'package:firebase/Screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import '../helper/shared_preference_helper.dart';
import 'homepage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    SharedPreferenceHelper.getUserLoggedIn().then((value) {
      Timer(
          Duration(seconds: 3),
          () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                if (value == null) {
                  return SignInScreen();
                } else {
                  return NewApp();
                }
              }
                  // (value == null) ? SignInPage() : BotomBar()
                  )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash_screen.jpg',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
            ),
          ],
        ),
      ),
    );
  }
}
