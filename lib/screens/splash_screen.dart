import 'package:flutter/material.dart';

import '../app_data.dart';
import '../utils/constants.dart';
import 'login_screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen(
      {Key? key,
      this.primaryColor,
      this.primaryTitle,
      this.mainLogoFileName,
      this.splashScreenDuration})
      : super(key: key);

  final Color? primaryColor;
  final String? primaryTitle;
  final String? mainLogoFileName;
  final Duration? splashScreenDuration;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  _navigateToLoginPage() async {
    await Future.delayed(const Duration(milliseconds: 1));
    if (!mounted) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Future<void> initialize(BuildContext context) async {
    AppData.primaryTitle = widget.primaryTitle!;
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: widget.splashScreenDuration);
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => setState(() {}));
    animationController.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: initialize(context),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.done) {
              _navigateToLoginPage();
            }
            return Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100.0),
                      child: Text(
                        AppData.primaryTitle,
                        style: const TextStyle(
                            color: kSecondaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w900),
                      ),
                    )
                  ],
                ),
                Center(
                  child: Image.asset(
                    "assets/images/${AppData.mainLogoFileName}",
                    height: animation.value * 250,
                    width: animation.value * 250,
                    color: kSecondaryColor,
                  ),
                ),
              ],
            );
          }),
    );
  }
}
