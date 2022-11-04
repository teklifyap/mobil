import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:teklifyap/utils/constants.dart';

class CustomInputField extends HookWidget {
  const CustomInputField(
      {Key? key, required this.labelText, required this.controller})
      : super(key: key);

  final String labelText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: kPrimaryColor),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
          ),
          focusColor: kPrimaryColor),
    );
  }
}
