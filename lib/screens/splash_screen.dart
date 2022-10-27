import 'package:flutter/material.dart';
import 'package:teklifyap/app_data.dart';
import 'package:teklifyap/screens/login_screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen(
      {Key? key,
      this.primaryColor,
      this.primaryTitle,
      this.mainLogoFileName,
      this.splashScreenDuration = const Duration(milliseconds: 1500)})
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
    if (widget.primaryTitle != null) {
      AppData.primaryTitle = widget.primaryTitle!;
    }
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
            return Center(
              child: Text(
                AppData.primaryTitle,
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: animation.value * 72),
              ),
            );
          }),
    );
  }
}
