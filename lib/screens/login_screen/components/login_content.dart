import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../animations/change_screen_animation.dart';
import 'bottom_text.dart';
import 'top_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:untitled/screens/language_picker/language_picker_widget.dart';

enum Screens {
  createAccount,
  welcomeBack,
}

class LoginContent extends StatefulWidget {
  const LoginContent({Key? key}) : super(key: key);

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent>
    with TickerProviderStateMixin {
  List<Widget>? loginContent;
  List<Widget>? createAccountContent;

  Widget inputField(String hint, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: SizedBox(
        height: 50,
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextField(
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              prefixIcon: Icon(iconData),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
          backgroundColor: kSecondaryColor,
          elevation: 8,
          shadowColor: Colors.black87,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget orDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 8),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 1,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              AppLocalizations.of(context)!.or.toLowerCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: 1,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget logos() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/facebook.png'),
          const SizedBox(width: 24),
          Image.asset('assets/images/google.png'),
        ],
      ),
    );
  }

  Widget forgotPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextButton(
        style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent)),
        onPressed: () {},
        child: Text(
          AppLocalizations.of(context)!.forgotPassword,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<String> initialization() async {
    createAccountContent = [
      inputField(AppLocalizations.of(context)!.username, Icons.person_outline),
      inputField(AppLocalizations.of(context)!.email, Icons.mail_outline),
      inputField(
          AppLocalizations.of(context)!.password, Icons.lock_clock_outlined),
      loginButton(AppLocalizations.of(context)!.signUp),
      orDivider(),
      logos(),
    ];

    loginContent = [
      inputField(
          AppLocalizations.of(context)!.emailOrUsername, Icons.mail_outline),
      inputField(
          AppLocalizations.of(context)!.password, Icons.lock_clock_outlined),
      loginButton(AppLocalizations.of(context)!.logIn),
      forgotPassword(),
    ];

    if (ChangeScreenAnimation.hasBeenInitialized == false) {
      ChangeScreenAnimation.initialize(
        vsync: this,
        createAccountItems: createAccountContent!.length,
        loginItems: loginContent!.length,
      );
    }

    for (var i = 0; i < createAccountContent!.length; i++) {
      createAccountContent![i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.createAccountAnimations[i],
        child: createAccountContent![i],
      );
    }

    for (var i = 0; i < loginContent!.length; i++) {
      loginContent![i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.loginAnimations[i],
        child: loginContent![i],
      );
    }

    return "Widgets created";
  }

  @override
  void dispose() {
    ChangeScreenAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: initialization(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                const Positioned(
                    top: 50, right: 5, child: LanguagePickerWidget()),
                const Positioned(
                  top: 136,
                  left: 24,
                  child: TopText(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Stack(
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: createAccountContent!),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: loginContent!),
                    ],
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 50),
                    child: BottomText(),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        });
  }
}
