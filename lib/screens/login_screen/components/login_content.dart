import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/* Local imports */
import 'package:teklifyap/screens/app/app.dart';
import 'package:teklifyap/screens/login_screen/language_picker/language_picker_widget.dart';
import 'package:teklifyap/screens/login_screen/animations/change_screen_animation.dart';
import 'package:teklifyap/screens/login_screen/components/bottom_text.dart';
import 'package:teklifyap/screens/login_screen/components/forgot_password.dart';
import 'package:teklifyap/screens/login_screen/components/top_text.dart';
import 'package:teklifyap/services/api/user_actions.dart';
import 'package:teklifyap/constants.dart';
import 'package:teklifyap/screens/login_screen/helper_functions.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

enum Screens {
  register,
  login,
  forgotPassword,
}

class LoginContent extends HookConsumerWidget {
  const LoginContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isBiggerThan700px = kIsWeb && MediaQuery.sizeOf(context).width > 700;
    final registerFormKey = GlobalKey<FormState>();
    final loginFormKey = GlobalKey<FormState>();
    final forgotPasswordFormKey = GlobalKey<FormState>();

    List<Widget>? loginScreen;
    List<Widget>? registerScreen;
    List<Widget>? forgotPasswordScreen;

    TextEditingController emailTextController = useTextEditingController();
    TextEditingController passwordTextController = useTextEditingController();
    TextEditingController registerRepeatPasswordTextController =
        useTextEditingController();
    TextEditingController nameTextController = useTextEditingController();
    TextEditingController surnameTextController = useTextEditingController();

    String? isEmptyValidator(String? value) {
      if (value == null || value.isEmpty) {
        return AppLocalizations.of(context)!.vldtCannotBeBlank;
      }
      return null;
    }

    String? emailValidator(String? value) {
      if (value == null || value.isEmpty) {
        return AppLocalizations.of(context)!.vldtEmailCannotBeBlank;
      } else if (!RegExp(r"""
^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""")
          .hasMatch(value)) {
        return AppLocalizations.of(context)!.vldtEnterAValidEmail;
      }
      return null;
    }

    String? passwordValidator(String? value) {
      if (value == null || value.isEmpty) {
        return AppLocalizations.of(context)!.vldtPasswordCannotBeBlank;
      } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z]).{8,}$').hasMatch(value) &&
          ChangeScreenAnimation.currentScreen != Screens.login) {
        return AppLocalizations.of(context)!.vldtPasswordRequirements;
      }
      return null;
    }

    String? repeatPasswordValidator(String? value) {
      if (value == null || value.isEmpty) {
        return AppLocalizations.of(context)!.vldtPasswordCannotBeBlank;
      } else if (value != passwordTextController.text) {
        return AppLocalizations.of(context)!.vldtPasswordsDoNotMatch;
      }
      return null;
    }

    Widget inputField(
        String hint,
        IconData iconData,
        bool isObscure,
        TextEditingController controller,
        String? Function(String?)? validator) {
      return HookBuilder(builder: (context) {
        final showPassword = useState(isObscure);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
          child: Material(
            elevation: 8,
            shadowColor: Colors.black87,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            child: TextFormField(
              validator: validator,
              controller: controller,
              textAlignVertical: TextAlignVertical.center,
              obscureText: showPassword.value,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                suffixIcon: isObscure
                    ? Padding(
                        padding: const EdgeInsets.only(right: 3.0),
                        child: InkWell(
                          onTap: () => showPassword.value = !showPassword.value,
                          child: const Icon(
                            Icons.remove_red_eye_outlined,
                            color: kPrimaryColor,
                          ),
                        ))
                    : null,
                prefixIcon: Icon(
                  iconData,
                  color: kPrimaryColor,
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: hint,
                errorStyle:
                    TextStyle(color: Colors.red.withOpacity(0.8), fontSize: 14),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: Colors.red.withOpacity(0.5), width: 3.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        );
      });
    }

    Route createRoute(Widget nextScreen) {
      return PageRouteBuilder(
        pageBuilder: (_, __, ___) => nextScreen,
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(0.0, 1.0),
              ).animate(secondaryAnimation),
              child: child,
            ),
          );
        },
      );
    }

    Widget multiFuncButton(String title) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
        child: ElevatedButton(
          onPressed: () async {
            if (ChangeScreenAnimation.currentScreen == Screens.register &&
                registerFormKey.currentState!.validate()) {
              await UserActions.register(
                  nameTextController.text,
                  surnameTextController.text,
                  emailTextController.text,
                  passwordTextController.text,
                  context);
              ChangeScreenAnimation.setCurrentScreen(Screens.login);
              if (!ChangeScreenAnimation.isPlaying) {
                await ChangeScreenAnimation.reverse();
              }
            } else if (ChangeScreenAnimation.currentScreen == Screens.login &&
                loginFormKey.currentState!.validate()) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(kPrimaryColor)),
                    );
                  });
              bool success = await UserActions.login(context,
                  emailTextController.text, passwordTextController.text);
              if (context.mounted && success) {
                Navigator.pop(context);
                Navigator.of(context).push(createRoute(App()));
              }
            } else {
              if (forgotPasswordFormKey.currentState!.validate()) {
                // TODO: send email button func
              }
            }
          },
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

    registerScreen = [
      inputField(AppLocalizations.of(context)!.name, Icons.person_outline,
          false, nameTextController, isEmptyValidator),
      inputField(AppLocalizations.of(context)!.surname, Icons.person_outline,
          false, surnameTextController, isEmptyValidator),
      inputField(AppLocalizations.of(context)!.email, Icons.mail_outline, false,
          emailTextController, emailValidator),
      inputField(
          AppLocalizations.of(context)!.password,
          Icons.lock_clock_outlined,
          true,
          passwordTextController,
          passwordValidator),
      inputField(
          AppLocalizations.of(context)!.repeatPassword,
          Icons.lock_clock_outlined,
          true,
          registerRepeatPasswordTextController,
          repeatPasswordValidator),
      multiFuncButton(AppLocalizations.of(context)!.signUp),
    ];

    loginScreen = [
      inputField(AppLocalizations.of(context)!.email, Icons.mail_outline, false,
          emailTextController, emailValidator),
      inputField(
          AppLocalizations.of(context)!.password,
          Icons.lock_clock_outlined,
          true,
          passwordTextController,
          passwordValidator),
      multiFuncButton(AppLocalizations.of(context)!.logIn),
      GestureDetector(
          onTap: () {
            forgotPasswordFormKey.currentState!.reset();
            if (!ChangeScreenAnimation.isPlaying) {
              ChangeScreenAnimation.forward(isForgotPassword: true);
              ChangeScreenAnimation.currentScreen = Screens.forgotPassword;
            }
          },
          behavior: HitTestBehavior.opaque,
          child: const ForgotPasswordButton()),
    ];

    forgotPasswordScreen = [
      inputField(AppLocalizations.of(context)!.email, Icons.mail_outline, false,
          emailTextController, emailValidator),
      multiFuncButton(AppLocalizations.of(context)!.sendEmail),
    ];

    if (ChangeScreenAnimation.hasBeenInitialized == false) {
      ChangeScreenAnimation.initialize(
          registerItems: registerScreen.length,
          loginItems: loginScreen.length,
          forgotPasswordItems: forgotPasswordScreen.length,
          isReverse: false);
    }

    for (var i = 0; i < registerScreen.length; i++) {
      registerScreen[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.registerAnimations[i],
        child: registerScreen[i],
      );
    }

    for (var i = 0; i < loginScreen.length; i++) {
      loginScreen[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.loginAnimations[i],
        child: loginScreen[i],
      );
    }

    for (var i = 0; i < forgotPasswordScreen.length; i++) {
      forgotPasswordScreen[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.forgotPasswordAnimations[i],
        child: forgotPasswordScreen[i],
      );
    }

    return Stack(
      children: [
        const Positioned(top: 50, right: 5, child: LanguagePickerWidget()),
        const Positioned(
          top: 120,
          left: 12,
          child: TopText(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Stack(
            children: [
              Form(
                key: forgotPasswordFormKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: forgotPasswordScreen),
              ),
              Form(
                key: registerFormKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: registerScreen),
              ),
              Form(
                key: loginFormKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: loginScreen),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: BottomText(
                loginFormKey: loginFormKey,
                registerFormKey: registerFormKey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
