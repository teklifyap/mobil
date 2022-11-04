import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:teklifyap/app_data.dart';
import 'package:teklifyap/screens/storage_screen/components/input_field.dart';
import 'package:teklifyap/screens/storage_screen/components/item_container.dart';
import 'package:teklifyap/services/services.dart';
import 'package:teklifyap/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StorageScreen extends HookWidget {
  const StorageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<String> units = <String>["M3", "M2", "KG", "LT", "ADET", "M"];
    final items = useState(AppData.storageItems);
    final itemsTrigger = useState(0);
    final itemNameController = useTextEditingController();
    final itemValueController = useTextEditingController();
    String itemUnitController = units.first;

    void addItem(List<String> value) {
      HttpService.itemCreate(value[0], int.parse(value[1]), value[2], context);
      items.value.add(value);
      itemsTrigger.value++;
      itemNameController.clear();
      itemValueController.clear();
    }

    void deleteItem(int index) {
      items.value.removeAt(index);
      itemsTrigger.value++;
      debugPrint("worked");
    }

    Future createItemDialog() async {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.newItem),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          content: HookBuilder(builder: (context) {
            final unitDropdown = useState(units.first);
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
                    // This is called when the user selects an item.
                    unitDropdown.value = value!;
                    itemUnitController = value!;
                  },
                  items: units.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
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
                      addItem([
                        itemNameController.text,
                        itemValueController.text,
                        itemUnitController,
                      ]);
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
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              AppLocalizations.of(context)!.storage,
              style: const TextStyle(fontSize: 32),
            ),
          ),
        ),
        items.value.isNotEmpty
            ? Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: items.value.length,
                  itemBuilder: (context, index) {
                    return ItemContainer(
                      itemTitle: items.value[index][0],
                      itemValue: items.value[index][1],
                      itemUnit: items.value[index][2],
                      deleteFunc: () => deleteItem(index),
                    );
                  },
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Center(
                    child:
                        Text(AppLocalizations.of(context)!.noItemInTheStorage)))
      ]),
    );
  }
}
