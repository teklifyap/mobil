import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/provider/item_provider.dart';
import 'package:teklifyap/screens/storage_screen/components/input_field.dart';
import 'package:teklifyap/services/api/item_actions.dart';
import 'package:teklifyap/services/models/item.dart';
import 'package:teklifyap/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemContainer extends HookConsumerWidget {
  const ItemContainer({Key? key, required this.item}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemValueController = useTextEditingController();
    final itemNameController = useTextEditingController();

    setEditInputFields() {
      itemValueController.text = '${item.value}';
      itemNameController.text = item.name!;
    }

    void deleteItem(Item item) async {
      await ItemActions.deleteItem(item.id as int);
      ref.read(itemsProvider).getItems();
    }

    void updateItem(Item item) async {
      item.name = itemNameController.text;
      item.value = double.parse(itemValueController.text);
      await ItemActions.updateItem(item);
      ref.read(itemsProvider).getItems();
    }

    Future editItem() async {
      setEditInputFields();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.editItem),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomInputField(
                  controller: itemNameController,
                  labelText: AppLocalizations.of(context)!.itemName),
              CustomInputField(
                controller: itemValueController,
                labelText: AppLocalizations.of(context)!.itemPrice,
              ),
            ],
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
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Card(
        color: kPrimaryColor,
        child: ListTile(
          onTap: editItem,
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
