import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:teklifyap/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class CustomInputField extends HookWidget {
  CustomInputField({
    Key? key,
    this.inputFormatters,
    this.textInputType,
    required this.labelText,
    required this.controller,
  }) : super(key: key);

  final String labelText;
  final TextEditingController controller;
  List<TextInputFormatter>? inputFormatters;
  TextInputType? textInputType;

  @override
  Widget build(BuildContext context) {
    String? isEmptyValidator(String? value) {
      if (value == null || value.isEmpty) {
        return AppLocalizations.of(context)!.vldtCannotBeBlank;
      }
      return null;
    }

    return TextFormField(
      inputFormatters: inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: isEmptyValidator,
      keyboardType: textInputType,
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
