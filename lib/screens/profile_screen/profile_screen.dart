import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:teklifyap/app_data.dart';
import 'package:teklifyap/utils/constants.dart';

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
          ],
        ),
      ),
    );
  }
}
