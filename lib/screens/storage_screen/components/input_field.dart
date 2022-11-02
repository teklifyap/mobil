import 'package:flutter/material.dart';
import 'package:teklifyap/utils/constants.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField({Key? key, required this.labelText}) : super(key: key);

  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
