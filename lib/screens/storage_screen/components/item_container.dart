import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:teklifyap/screens/storage_screen/components/input_field.dart';
import 'package:teklifyap/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemContainer extends HookWidget {
  const ItemContainer({
    Key? key,
    required this.itemTitle,
    required this.itemValue,
    required this.itemUnit,
    required this.deleteFunc,
  }) : super(key: key);

  final String itemTitle;
  final String itemValue;
  final String itemUnit;
  final VoidCallback deleteFunc;

  @override
  Widget build(BuildContext context) {
    final itemCodeController = useTextEditingController();

    Future openEditDialog() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(itemTitle),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            content: CustomInputField(
              controller: itemCodeController,
              labelText: AppLocalizations.of(context)!.itemPrice,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: Row(
                      children: [
                        const Icon(
                          Icons.save,
                          color: kPrimaryColor,
                        ),
                        Text(
                          AppLocalizations.of(context)!.savePrice,
                          style: const TextStyle(color: kPrimaryColor),
                        )
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      deleteFunc();
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete,
                          color: kPrimaryColor,
                        ),
                        Text(
                          AppLocalizations.of(context)!.deleteItem,
                          style: const TextStyle(color: kPrimaryColor),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Card(
        color: kPrimaryColor,
        child: ListTile(
          onTap: openEditDialog,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                itemTitle,
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                itemValue,
                style: const TextStyle(color: Colors.black26),
              ),
              Text(
                itemUnit,
                style: const TextStyle(color: Colors.black26),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
