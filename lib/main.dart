import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kPrimaryColor),
      ),
      home: const SplashScreen(
        primaryColor: kPrimaryColor,
        primaryTitle: "Guess The Song",
        mainLogoFileName: "main_logo.png",
        splashScreenDuration: Duration(milliseconds: 1500),
      ),
    );
  }
}
