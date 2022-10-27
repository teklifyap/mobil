import 'package:flutter/material.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({Key? key}) : super(key: key);

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Storage Screen"),
      ),
    );
  }
}
