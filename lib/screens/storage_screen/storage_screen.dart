import 'package:flutter/material.dart';
import 'package:teklifyap/screens/storage_screen/components/input_field.dart';
import 'package:teklifyap/screens/storage_screen/components/item_container.dart';
import 'package:teklifyap/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({Key? key}) : super(key: key);

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  List<ItemContainer> items = [
    const ItemContainer(
      itemTitle: "Item name",
      itemCode: "C20",
    )
  ];

  Future createItemDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomInputField(
                  labelText: AppLocalizations.of(context)!.itemName),
              CustomInputField(
                  labelText: AppLocalizations.of(context)!.itemUnit),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextButton(
                    onPressed: () => {Navigator.pop(context)},
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

  @override
  Widget build(BuildContext context) {
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
        items.isNotEmpty
            ? Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return items[index];
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
