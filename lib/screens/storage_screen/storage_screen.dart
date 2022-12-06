import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/provider/item_provider.dart';
import 'package:teklifyap/screens/storage_screen/components/input_field.dart';
import 'package:teklifyap/screens/storage_screen/components/item_container.dart';
import 'package:teklifyap/services/api/item_actions.dart';
import 'package:teklifyap/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teklifyap/services/models/item.dart';

// ignore: constant_identifier_names
enum Units { M3, M2, KG, LT, ADET, M }

class StorageScreen extends HookConsumerWidget {
  const StorageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemNameController = useTextEditingController();
    final itemValueController = useTextEditingController();
    String itemUnitController = Units.KG.name;

    void addItem(Item item) async {
      await ItemActions.createItem(item);
      ref.read(itemsProvider).getItems();
      itemNameController.clear();
      itemValueController.clear();
    }

    Future createItemDialog() async {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.newItem),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          content: HookBuilder(builder: (context) {
            final unitDropdown = useState(Units.KG.name);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomInputField(
                    controller: itemNameController,
                    labelText: AppLocalizations.of(context)!.itemName),
                CustomInputField(
                    controller: itemValueController,
                    labelText: AppLocalizations.of(context)!.itemValue),
                DropdownButton<String>(
                  value: unitDropdown.value,
                  icon: const Icon(
                    Icons.arrow_downward,
                    color: kPrimaryColor,
                  ),
                  elevation: 16,
                  style: const TextStyle(color: kPrimaryColor),
                  underline: Container(
                    height: 2,
                    color: kPrimaryColor,
                  ),
                  onChanged: (String? value) {
                    unitDropdown.value = value!;
                    itemUnitController = value;
                  },
                  items: Units.values
                      .map<DropdownMenuItem<String>>((unit) => DropdownMenuItem(
                            value: unit.name,
                            child: Text(unit.name),
                          ))
                      .toList(),
                ),
              ],
            );
          }),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextButton(
                    onPressed: () {
                      addItem(Item(
                          name: itemNameController.text,
                          value: double.parse(itemValueController.text),
                          unit: itemUnitController));
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add,
                          color: kPrimaryColor,
                        ),
                        Text(
                          AppLocalizations.of(context)!.addItem,
                          style: const TextStyle(color: kPrimaryColor),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: createItemDialog,
        label: Row(
          children: [
            const Icon(Icons.add),
            Text(AppLocalizations.of(context)!.newItem),
          ],
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(children: [
        Padding(
            padding: const EdgeInsets.only(top: 60, left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.storage,
                  style: const TextStyle(fontSize: 32),
                ),
                IconButton(
                    onPressed: () => {ref.read(itemsProvider).getItems()},
                    icon: const Icon(
                      Icons.refresh,
                      color: kPrimaryColor,
                      size: 32,
                    )),
              ],
            )),
        Consumer(builder: (context, ref, child) {
          final itemProvider = ref.watch(itemsProvider);
          return itemProvider.items.isNotEmpty
              ? Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemCount: itemProvider.items.length,
                    itemBuilder: (context, index) {
                      return ItemContainer(item: itemProvider.items[index]);
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: Center(
                      child: Text(
                          AppLocalizations.of(context)!.noItemInTheStorage)));
        })
      ]),
    );
  }
}
