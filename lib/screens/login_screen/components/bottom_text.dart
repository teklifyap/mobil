import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teklifyap/screens/login_screen/animations/change_screen_animation.dart';
import 'package:teklifyap/screens/login_screen/helper_functions.dart';

import 'login_content.dart';

class BottomText extends StatefulWidget {
  final GlobalKey<FormState> loginFormKey;
  final GlobalKey<FormState> registerFormKey;

  const BottomText(
      {Key? key, required this.loginFormKey, required this.registerFormKey})
      : super(key: key);

  @override
  State<BottomText> createState() => _BottomTextState();
}

class _BottomTextState extends State<BottomText> {
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
      animation: ChangeScreenAnimation.bottomTextAnimation,
      child: ChangeScreenAnimation.currentScreen == Screens.forgotPassword
          ? Container()
          : GestureDetector(
              onTap: () {
                if (!ChangeScreenAnimation.isPlaying) {
                  ChangeScreenAnimation.currentScreen == Screens.login
                      ? ChangeScreenAnimation.forward()
                      : ChangeScreenAnimation.reverse();

                  if (ChangeScreenAnimation.currentScreen == Screens.register) {
                    ChangeScreenAnimation.currentScreen = Screens.login;
                    widget.loginFormKey.currentState!.reset();
                  } else {
                    ChangeScreenAnimation.currentScreen = Screens.register;
                    widget.registerFormKey.currentState!.reset();
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
                                  Screens.register
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
