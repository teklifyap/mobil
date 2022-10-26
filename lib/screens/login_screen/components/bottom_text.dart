import 'package:flutter/material.dart';
import 'package:untitled/screens/login_screen/animations/change_screen_animation.dart';
import 'package:untitled/utils/helper_functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'login_content.dart';

class BottomText extends StatefulWidget {
  const BottomText({Key? key}) : super(key: key);

  @override
  State<BottomText> createState() => _BottomTextState();
}

class _BottomTextState extends State<BottomText> {
  @override
  void initState() {
    ChangeScreenAnimation.bottomTextAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HelperFunctions.wrapWithAnimatedBuilder(
      animation: ChangeScreenAnimation.bottomTextAnimation,
      child: ChangeScreenAnimation.currentScreen == Screens.forgotPassword
          ? Container()
          : GestureDetector(
              onTap: () {
                if (!ChangeScreenAnimation.isPlaying) {
                  ChangeScreenAnimation.currentScreen == Screens.welcomeBack
                      ? ChangeScreenAnimation.forward()
                      : ChangeScreenAnimation.reverse();

                  if (ChangeScreenAnimation.currentScreen ==
                      Screens.createAccount) {
                    ChangeScreenAnimation.currentScreen = Screens.welcomeBack;
                  } else {
                    ChangeScreenAnimation.currentScreen = Screens.createAccount;
                  }
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                      ),
                      children: [
                        TextSpan(
                          text: ChangeScreenAnimation.currentScreen ==
                                  Screens.createAccount
                              ? AppLocalizations.of(context)!
                                  .alreadyHaveAnAccount
                              : AppLocalizations.of(context)!
                                  .doNotHaveAnAccount,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
