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

  static confirmActionMessage(
      BuildContext context, VoidCallback action, String actionMessage) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    if (isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          content: Text(
            actionMessage,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: action,
              child: Text(AppLocalizations.of(context)!.okay),
            ),
            CupertinoDialogAction(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text(
            actionMessage,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          actions: [
            TextButton(
              onPressed: action,
              child: Text(AppLocalizations.of(context)!.okay),
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    }
  }
}
