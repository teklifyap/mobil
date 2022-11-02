import 'package:flutter/material.dart';
import 'package:teklifyap/screens/login_screen/animations/change_screen_animation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordButton extends StatefulWidget {
  const ForgotPasswordButton({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordButton> createState() => _ForgotPasswordButtonState();
}

class _ForgotPasswordButtonState extends State<ForgotPasswordButton> {
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
    return Padding(
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
                text: AppLocalizations.of(context)!.forgotPassword,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
