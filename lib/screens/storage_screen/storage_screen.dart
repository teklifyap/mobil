import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/custom_widgets/custom_dialog.dart';
import 'package:teklifyap/providers/item_provider.dart';
import 'package:teklifyap/custom_widgets/input_field.dart';
import 'package:teklifyap/screens/storage_screen/components/item_container.dart';
import 'package:teklifyap/services/api/item_actions.dart';
import 'package:teklifyap/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teklifyap/services/models/item.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// ignore: constant_identifier_names
enum Units { M3, M2, KG, LT, ADET, M }

class StorageScreen extends HookConsumerWidget {
  const StorageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemNameController = useTextEditingController();
    final itemValueController = useTextEditingController();
    String itemUnitController = Units.KG.name;
    final width = MediaQuery.of(context).size.width;

    var items = [...ref.read(itemsProvider)];
    if (items.where((element) => element.value == 0).toList().isNotEmpty) {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: kSecondaryColor,
            content: Center(
              child: Text(
                AppLocalizations.of(context)!.alertForZeroValue,
                style: const TextStyle(color: kPrimaryColor),
              ),
            )));
      });
    }

    void addItem(Item item) async {
      await ItemActions().createItem(item);
      ref.read(itemsProvider.notifier).getItems();
      itemNameController.clear();
      itemValueController.clear();
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CustomDialogs().basicAddOrCreateDialog(
            content: [
              CustomInputField(
                  controller: itemNameController,
                  labelText: AppLocalizations.of(context)!.itemName),
              CustomInputField(
                controller: itemValueController,
                labelText: AppLocalizations.of(context)!.itemValue,
                textInputType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              HookBuilder(builder: ((context) {
                final unitDropdown = useState(Units.KG.name);
                return DropdownButton<String>(
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
                );
              }))
            ],
            title: AppLocalizations.of(context)!.newItem,
            actionText: AppLocalizations.of(context)!.addItem,
            actionIcon: Icons.add,
            action: () {
              addItem(Item(
                  name: itemNameController.text,
                  value: double.parse(itemValueController.text),
                  unit: itemUnitController));
              Navigator.pop(context);
            },
            context: context),
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
                    onPressed: () =>
                        {ref.read(itemsProvider.notifier).getItems()},
                    icon: const Icon(
                      Icons.refresh,
                      color: kPrimaryColor,
                      size: 32,
                    )),
              ],
            )),
        Consumer(builder: (context, ref, child) {
          final itemProvider = ref.watch(itemsProvider);
          return itemProvider.isNotEmpty
              ? Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            kIsWeb ? (width <= 1000 ? width ~/ 150 : 8) : 3),
                    itemCount: itemProvider.length,
                    itemBuilder: (context, index) {
                      return ItemContainer(item: itemProvider[index]);
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
