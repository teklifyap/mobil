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
      child: ChangeScreenAnimation.currentScreen == Screens.forgotPassword
          ? Text(
              AppLocalizations.of(context)!.forgotPasswordTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w600,
              ),
            )
          : Text(
              ChangeScreenAnimation.currentScreen == Screens.register
                  ? AppLocalizations.of(context)!.createAccount
                  : AppLocalizations.of(context)!.welcomeBack,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
