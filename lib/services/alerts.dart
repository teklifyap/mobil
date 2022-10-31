import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomAlerts {
  static errorOccurredMessage(BuildContext context, String errorMessage) {
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              content: Text(
                errorMessage,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text(AppLocalizations.of(context)!.okay),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }
}
