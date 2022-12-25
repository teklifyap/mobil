import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:teklifyap/app_data.dart';
import 'package:teklifyap/constants.dart';
import 'package:teklifyap/screens/app/app.dart';
import 'package:teklifyap/screens/login_screen/login_screen.dart';
import 'package:teklifyap/services/api/user_actions.dart';

class SplashScreen extends HookWidget {
  const SplashScreen(
      {Key? key,
      this.primaryTitle,
      this.mainLogoFileName,
      this.splashScreenDuration = const Duration(milliseconds: 1500)})
      : super(key: key);

  final String? primaryTitle;
  final String? mainLogoFileName;
  final Duration splashScreenDuration;

  @override
  Widget build(BuildContext context) {
    AnimationController animationController =
        useAnimationController(duration: splashScreenDuration);
    animationController.forward();
    String? userToken;

    navigateToLoginPage() async {
      Widget screenToNavigate = const LoginScreen();
      userToken = await UserActions().getUserToken();
      if (userToken != null) {
        AppData.authToken = userToken ?? "";
        screenToNavigate = App();
      }
      await Future.delayed(splashScreenDuration);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => screenToNavigate));
    }

    Future<void> initialize(BuildContext context) async {
      if (primaryTitle != null) {
        AppData.primaryTitle = primaryTitle!;
      }
      await navigateToLoginPage();
    }

    return Scaffold(
      body: FutureBuilder(
          future: initialize(context),
          builder: (context, snap) {
            return TweenAnimationBuilder(
                tween: Tween<double>(begin: 160, end: 640),
                duration: splashScreenDuration,
                builder: (context, value, child) {
                  return Center(
                    child: Text(
                      AppData.primaryTitle,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: value / 10,
                          color: kPrimaryColor),
                    ),
                  );
                });
          }),
    );
  }
}
