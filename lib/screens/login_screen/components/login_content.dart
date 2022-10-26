import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teklifyap/screens/language_picker/language_picker_widget.dart';
import 'package:teklifyap/screens/login_screen/animations/change_screen_animation.dart';
import 'package:teklifyap/screens/login_screen/components/bottom_text.dart';
import 'package:teklifyap/screens/login_screen/components/top_text.dart';
import 'package:teklifyap/utils/constants.dart';
import 'package:teklifyap/utils/helper_functions.dart';

enum Screens {
  createAccount,
  welcomeBack,
  forgotPassword,
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
  List<Widget>? forgotPasswordScreen;
  List<Widget>? loginContent2;
  List<Widget>? createAccountContent2;
  List<Widget>? forgotPasswordScreen2;

  Widget inputField(String hint, IconData iconData, bool isObscure) {
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
            obscureText: isObscure,
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

  Widget otherLoginOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () => {},
              child: Image.asset('assets/images/facebook.png')),
          const SizedBox(width: 24),
          GestureDetector(
              onTap: () => {}, child: Image.asset('assets/images/google.png')),
        ],
      ),
    );
  }

  Widget sendEmailButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 120.0, vertical: 16),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
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

  Widget forgotPasswordButton() {
    return GestureDetector(
      onTap: () {
        if (!ChangeScreenAnimation.isPlaying) {
          ChangeScreenAnimation.forward(isForgotPassword: true);

          ChangeScreenAnimation.currentScreen = Screens.forgotPassword;
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
      ),
    );
  }

  Future<String> initialization() async {
    createAccountContent = [
      inputField(
          AppLocalizations.of(context)!.name, Icons.person_outline, false),
      inputField(
          AppLocalizations.of(context)!.surname, Icons.person_outline, false),
      inputField(
          AppLocalizations.of(context)!.email, Icons.mail_outline, false),
      inputField(AppLocalizations.of(context)!.password,
          Icons.lock_clock_outlined, true),
      inputField(AppLocalizations.of(context)!.repeatPassword,
          Icons.lock_clock_outlined, true),
      loginButton(AppLocalizations.of(context)!.signUp),
      orDivider(),
      otherLoginOptions(),
    ];

    loginContent = [
      inputField(
          AppLocalizations.of(context)!.email, Icons.mail_outline, false),
      inputField(AppLocalizations.of(context)!.password,
          Icons.lock_clock_outlined, true),
      loginButton(AppLocalizations.of(context)!.logIn),
      forgotPasswordButton(),
    ];

    forgotPasswordScreen = [
      inputField(
          AppLocalizations.of(context)!.email, Icons.mail_outline, false),
      sendEmailButton(AppLocalizations.of(context)!.sendEmail),
    ];

    if (ChangeScreenAnimation.hasBeenInitialized == false) {
      ChangeScreenAnimation.initialize(
          vsync: this,
          createAccountItems: createAccountContent!.length,
          loginItems: loginContent!.length,
          forgotPasswordItems: forgotPasswordScreen!.length,
          isReverse: false);
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

    for (var i = 0; i < forgotPasswordScreen!.length; i++) {
      forgotPasswordScreen![i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.forgotPasswordAnimations[i],
        child: forgotPasswordScreen![i],
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
                  top: 120,
                  left: 12,
                  child: TopText(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Stack(
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: forgotPasswordScreen!),
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
                  child: SizedBox(
                    height: 100,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 50),
                      child: BottomText(),
                    ),
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
