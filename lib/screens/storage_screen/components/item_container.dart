import 'package:flutter/material.dart';
import 'package:teklifyap/screens/storage_screen/components/input_field.dart';
import 'package:teklifyap/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemContainer extends StatefulWidget {
  const ItemContainer({
    Key? key,
    required this.itemTitle,
    required this.itemCode,
  }) : super(key: key);

  final String itemTitle;
  final String itemCode;

  @override
  State<ItemContainer> createState() => _ItemContainerState();
}

class _ItemContainerState extends State<ItemContainer> {
  Future openEditDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(widget.itemTitle),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          content: CustomInputField(
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
                  onPressed: () => {Navigator.pop(context)},
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

  @override
  Widget build(BuildContext context) {
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
                widget.itemTitle,
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                widget.itemCode,
                style: const TextStyle(color: Colors.black26),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
