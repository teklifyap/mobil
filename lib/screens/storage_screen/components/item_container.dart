import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:teklifyap/app_data.dart';
import 'package:teklifyap/screens/storage_screen/components/input_field.dart';
import 'package:teklifyap/services/api/item_actions.dart';
import 'package:teklifyap/services/models/item.dart';
import 'package:teklifyap/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemContainer extends HookWidget {
  const ItemContainer({Key? key, required this.item}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    final itemValueController = useTextEditingController();

    void deleteItem(Item item) async {
      await ItemActions.deleteItem(item.id as int);
      await ItemActions.getAllItems();
      AppData.triggerStorageItems();
      //todo: ekran yenilenmiyor
    }

    void updateItem(Item item) async {
      item.value = double.parse(itemValueController.text);
      itemValueController.clear();
      await ItemActions.updateItem(item);
      await ItemActions.getAllItems();
      AppData.triggerStorageItems();
      //todo: ekran yenilenmiyor
    }

    Future openEditDialog() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(item.name ?? ""),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            content: CustomInputField(
              controller: itemValueController,
              labelText: AppLocalizations.of(context)!.itemPrice,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      updateItem(item);
                      Navigator.pop(context);
                    },
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
                      deleteItem(item);
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
                item.name ?? "",
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                '${item.value ?? 0.0}',
                style: const TextStyle(color: Colors.black26),
              ),
              Text(
                item.unit ?? "",
                style: const TextStyle(color: Colors.black26),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
