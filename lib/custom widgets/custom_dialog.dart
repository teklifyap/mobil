import 'package:flutter/material.dart';
import 'package:teklifyap/constants.dart';

class CustomDialogs {
  static Future basicAddOrCreateDialog({
    required List<Widget> content,
    required String title,
    required String actionText,
    required IconData actionIcon,
    required VoidCallback action,
    required BuildContext context,
    List<TextEditingController>? textEditingControllers,
  }) async {
    if (textEditingControllers != null) {
      for (final controller in textEditingControllers) {
        controller.clear();
      }
    }
    final formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              content: SingleChildScrollView(
                  child: Form(
                key: formKey,
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: content),
              )),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            action();
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              actionIcon,
                              color: kPrimaryColor,
                            ),
                            Text(
                              actionText,
                              style: const TextStyle(color: kPrimaryColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ));
  }

  static Future basicEditDialog({
    required BuildContext context,
    required String title,
    required List<Widget> content,
    VoidCallback? leftButtonAction,
    bool doesLeftButtonNeedValidation = false,
    VoidCallback? rightButtonAction,
    bool doesRightButtonNeedValidation = false,
    IconData? leftButtonIcon,
    IconData? rightButtonIcon,
    String? leftButtonText,
    String? rightButtonText,
  }) async {
    final formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: content,
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    leftButtonAction != null && leftButtonText != null
                        ? TextButton(
                            onPressed: () {
                              if (doesLeftButtonNeedValidation) {
                                if (formKey.currentState!.validate()) {
                                  leftButtonAction();
                                }
                              } else {
                                leftButtonAction();
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  leftButtonIcon,
                                  color: kPrimaryColor,
                                ),
                                Text(
                                  leftButtonText,
                                  style: const TextStyle(color: kPrimaryColor),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    rightButtonAction != null && rightButtonText != null
                        ? TextButton(
                            onPressed: () {
                              if (doesRightButtonNeedValidation) {
                                if (formKey.currentState!.validate()) {
                                  rightButtonAction();
                                }
                              } else {
                                debugPrint("wa");
                                rightButtonAction();
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  rightButtonIcon,
                                  color: kPrimaryColor,
                                ),
                                Text(
                                  rightButtonText,
                                  style: const TextStyle(color: kPrimaryColor),
                                )
                              ],
                            ),
                          )
                        : Container()
                  ],
                )
              ],
            ));
  }
}
