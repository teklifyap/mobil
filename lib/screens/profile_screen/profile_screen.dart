import 'package:flutter/material.dart';
import 'package:teklifyap/app_data.dart';
import 'package:teklifyap/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
              AppData.currentUser["email"],
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              AppData.currentUser["name"],
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              AppData.currentUser["surname"],
              style: const TextStyle(fontSize: 24),
            )
          ],
        ),
      ),
    );
  }
}
