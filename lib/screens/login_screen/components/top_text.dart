import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teklifyap/screens/login_screen/animations/change_screen_animation.dart';
import 'package:teklifyap/utils/helper_functions.dart';

import 'login_content.dart';

class TopText extends StatefulWidget {
  const TopText({Key? key}) : super(key: key);

  @override
  State<TopText> createState() => _TopTextState();
}

class _TopTextState extends State<TopText> {
  @override
  void initState() {
    ChangeScreenAnimation.topTextAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HelperFunctions.wrapWithAnimatedBuilder(
      animation: ChangeScreenAnimation.topTextAnimation,
      child: (() {
        String title = "";
        switch (ChangeScreenAnimation.currentScreen) {
          case Screens.forgotPassword:
            title = AppLocalizations.of(context)!.forgotPasswordTitle;
            break;
          case Screens.login:
            title = AppLocalizations.of(context)!.welcomeBack;
            break;
          case Screens.register:
            title = AppLocalizations.of(context)!.createAccount;
            break;
        }
        return Text(title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w600,
            ));
      }()),
    );
  }
}
