import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/constants.dart';
import 'package:teklifyap/custom%20widgets/custom_dialog.dart';
import 'package:teklifyap/providers/user_provider.dart';
import 'package:teklifyap/screens/login_screen/language_picker/language_picker_widget.dart';
import 'package:teklifyap/custom%20widgets/input_field.dart';
import 'package:teklifyap/services/alerts.dart';
import 'package:teklifyap/services/api/user_actions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teklifyap/services/models/user.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final surnameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final newPasswordController = useTextEditingController();

    setControllers() {
      final profile = ref.read(userProvider);
      nameController.text = profile.user!.name!;
      surnameController.text = profile.user!.surname!;
      emailController.text = profile.user!.email!;
      passwordController.clear();
      newPasswordController.clear();
    }

    return Consumer(
      builder: (context, ref, child) {
        final profileProvider = ref.watch(userProvider);
        return Scaffold(
          body: Center(
            child: Stack(
              children: [
                const Positioned(
                    top: 50, right: 5, child: LanguagePickerWidget()),
                Positioned(
                  top: 100,
                  right: 10,
                  child: IconButton(
                    onPressed: () {
                      setControllers();
                      CustomDialogs.basicEditDialog(
                          context: context,
                          title: AppLocalizations.of(context)!.editProfile,
                          content: [
                            CustomInputField(
                                labelText: AppLocalizations.of(context)!.name,
                                controller: nameController),
                            CustomInputField(
                                labelText:
                                    AppLocalizations.of(context)!.surname,
                                controller: surnameController),
                            CustomInputField(
                                labelText: AppLocalizations.of(context)!.email,
                                controller: emailController),
                            CustomInputField(
                                labelText:
                                    AppLocalizations.of(context)!.password,
                                controller: passwordController),
                            HookBuilder(builder: (context) {
                              final isPasswordChange = useState(false);
                              return isPasswordChange.value
                                  ? CustomInputField(
                                      labelText: AppLocalizations.of(context)!
                                          .newPassword,
                                      controller: newPasswordController)
                                  : TextButton(
                                      onPressed: () {
                                        isPasswordChange.value = true;
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .clickHereToChangePassword,
                                        style: const TextStyle(
                                            color: kPrimaryColor),
                                      ));
                            })
                          ],
                          leftButtonAction: null,
                          rightButtonAction: () async {
                            await UserActions.updateUser(
                                User(
                                    id: 999,
                                    name: nameController.text,
                                    surname: surnameController.text,
                                    email: emailController.text),
                                passwordController.text,
                                newPasswordController.text);
                            ref.read(userProvider).getUser();
                            if (context.mounted) Navigator.pop(context);
                          },
                          leftButtonIcon: null,
                          rightButtonIcon: Icons.done,
                          leftButtonText: null,
                          rightButtonText: "",
                          doesRightButtonNeedValidation: true);
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        child: Container(
                          width: 150,
                          height: 150,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: kPrimaryColor,
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              '${profileProvider.user!.name!.substring(0, 1)}${profileProvider.user!.surname!.substring(0, 1)}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 48)),
                        ),
                      ),
                    ),
                    Text(
                      '${profileProvider.user!.name} ${profileProvider.user!.surname}',
                      style: const TextStyle(fontSize: 24),
                    ),
                    Text(
                      profileProvider.user!.email ?? "",
                      style: const TextStyle(fontSize: 24),
                    ),
                    TextButton(
                        onPressed: () => {
                              CustomAlerts.confirmActionMessage(context, () {
                                UserActions.deleteUser(context);
                              },
                                  AppLocalizations.of(context)!
                                      .confirmAccountDelete)
                            },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.delete,
                              color: kPrimaryColor,
                            ),
                            Text(
                              AppLocalizations.of(context)!.deleteMyAccount,
                              style: const TextStyle(color: kPrimaryColor),
                            )
                          ],
                        )),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
