import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/custom%20widgets/custom_dialog.dart';
import 'package:teklifyap/providers/item_provider.dart';
import 'package:teklifyap/custom%20widgets/input_field.dart';
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
      itemValueController.text = item.value.toString();
      itemNameController.text = item.name ?? "";
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Card(
        color: kPrimaryColor,
        child: ListTile(
          onTap: () {
            setEditInputFields();
            CustomDialogs.basicEditDialog(
                context: context,
                title: AppLocalizations.of(context)!.editItem,
                content: [
                  CustomInputField(
                      controller: itemNameController,
                      labelText: AppLocalizations.of(context)!.itemName),
                  CustomInputField(
                    controller: itemValueController,
                    labelText: AppLocalizations.of(context)!.itemPrice,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textInputType: TextInputType.number,
                  ),
                ],
                leftButtonAction: () {
                  deleteItem(item);
                  Navigator.pop(context);
                },
                rightButtonAction: () {
                  updateItem(item);
                  Navigator.pop(context);
                },
                leftButtonIcon: Icons.delete,
                rightButtonIcon: Icons.save,
                leftButtonText: AppLocalizations.of(context)!.deleteItem,
                rightButtonText: AppLocalizations.of(context)!.savePrice,
                doesRightButtonNeedValidation: true);
          },
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
