import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:teklifyap/app_data.dart';
import 'package:teklifyap/constants.dart';
import 'package:teklifyap/services/alerts.dart';
import 'package:teklifyap/services/api/user_actions.dart';

class ProfileScreen extends HookWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person,
              size: 360,
              color: kPrimaryColor,
            ),
            Text(
              '${AppData.currentUser?.name} ${AppData.currentUser?.surname}',
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              AppData.currentUser?.email ?? "",
              style: const TextStyle(fontSize: 24),
            ),
            TextButton(
                onPressed: () => {
                      CustomAlerts.confirmActionMessage(context, () {
                        UserActions.deleteUser(context);
                        //todo: dile ekle
                      }, "Are you sure? All data will be deleted after you confirm mail in your email")
                    },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.delete,
                      color: kPrimaryColor,
                    ),
                    Text(
                      "Delete my account!",
                      //todo: dile bunu ekle
                      style: TextStyle(color: kPrimaryColor),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
