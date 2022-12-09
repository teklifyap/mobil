import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/provider/item_provider.dart';
import 'package:teklifyap/provider/offer_provider.dart';
import 'package:teklifyap/provider/user_provider.dart';
import 'package:teklifyap/screens/offers_screen/components/offer_container.dart';
import 'package:teklifyap/screens/storage_screen/components/input_field.dart';
import 'package:teklifyap/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teklifyap/services/api/offer_actions.dart';
import 'package:teklifyap/services/models/item.dart';
import 'package:teklifyap/services/models/offer.dart';

class OffersScreen extends HookConsumerWidget {
  const OffersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offerTitleController = useTextEditingController();
    final receiverNameController = useTextEditingController();
    final profitRateController = useTextEditingController();
    List<TextEditingController> selectedItemsQuantities = [];
    List<int> selectedItemIDS = [];
    List<Item> selectedItems = [];
    // DateTime dateController = DateTime.now();

    void addOffer() async {
      final profile = ref.read(userProvider);
      await OfferActions.createOffer(Offer(
          title: offerTitleController.text,
          receiverName: receiverNameController.text,
          userName: '${profile.user!.name} ${profile.user!.surname}',
          profitRate: double.parse(profitRateController.text),
          items: selectedItems));
      ref.read(offersProvider).getOffers();
    }

    Future addItemsToOfferDialog(List<Item> addableItems) async {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.selectItems),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                content: SizedBox(
                  width: double.maxFinite,
                  child: addableItems.isEmpty
                      ? Text(AppLocalizations.of(context)!.youAddedAllItems)
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: addableItems.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                            color: kPrimaryColor,
                            thickness: 1.5,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return HookBuilder(
                              builder: (BuildContext context) {
                                final isSelected = useState(false);
                                final quantityController =
                                    useTextEditingController();
                                return ListTile(
                                    onTap: () {
                                      if (isSelected.value) {
                                        selectedItemIDS.removeLast();
                                        selectedItemsQuantities.removeLast();
                                      } else {
                                        selectedItemsQuantities
                                            .add(quantityController);
                                        selectedItemIDS
                                            .add(addableItems[index].id!);
                                      }
                                      isSelected.value = !isSelected.value;
                                    },
                                    title: Text(addableItems[index].name ?? ""),
                                    trailing: isSelected.value
                                        ? SizedBox(
                                            width: 120,
                                            child: CustomInputField(
                                              labelText:
                                                  AppLocalizations.of(context)!
                                                      .itemQuantity,
                                              controller: quantityController,
                                            ),
                                          )
                                        : Container(
                                            width: 1,
                                          ));
                              },
                            );
                          },
                        ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: IconButton(
                            onPressed: () {
                              if (addableItems.isNotEmpty) {
                                var itemsToRemove = [];
                                selectedItemsQuantities
                                    .asMap()
                                    .forEach((key, value) {
                                  if (value.text.isEmpty) {
                                    itemsToRemove.add(key);
                                  }
                                });
                                if (itemsToRemove.isNotEmpty) {
                                  itemsToRemove.asMap().forEach((key, value) {
                                    selectedItemsQuantities.removeAt(value);
                                    selectedItemIDS.removeAt(value);
                                  });
                                }
                                selectedItemIDS.asMap().forEach((i, x) {
                                  addableItems.removeWhere(
                                      (element) => element.id == x);
                                  selectedItems.add(Item(
                                      id: x,
                                      quantity: double.parse(
                                          selectedItemsQuantities[i].text),
                                      value: ref
                                          .read(itemsProvider)
                                          .items[i]
                                          .value));
                                });
                              }
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.done,
                              color: kPrimaryColor,
                            )),
                      )
                    ],
                  )
                ],
              ));
    }

    Future createOfferDialog() async {
      ref.read(itemsProvider).getItems();
      final addableItems = ref.read(itemsProvider);
      selectedItemIDS = [];
      selectedItemsQuantities = [];
      selectedItems = [];
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.newOffer),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          content: HookBuilder(builder: (context) {
            // DateTime currentDate = DateTime.now();
            // final selectedDate = useState(currentDate);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomInputField(
                    controller: offerTitleController,
                    labelText: AppLocalizations.of(context)!.offerTitle),
                CustomInputField(
                    controller: receiverNameController,
                    labelText: AppLocalizations.of(context)!.offerReceiver),
                // Padding(
                //   padding: const EdgeInsets.only(top: 16.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text('${AppLocalizations.of(context)!.date}: '),
                //       GestureDetector(
                //           child: Text(
                //               '${selectedDate.value.year}/${selectedDate.value.month}/${selectedDate.value.day}'),
                //           onTap: () async {
                //             DateTime? newDate = await showDatePicker(
                //               context: context,
                //               initialDate: currentDate,
                //               firstDate: DateTime(1990),
                //               lastDate: DateTime(2100),
                //             );
                //
                //             if (newDate == null) {
                //               return;
                //             }
                //
                //             selectedDate.value = newDate;
                //           })
                //     ],
                //   ),
                // ),
                CustomInputField(
                    controller: profitRateController,
                    labelText: AppLocalizations.of(context)!.profitRate),
                TextButton(
                    onPressed: () => addItemsToOfferDialog(addableItems.items),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add,
                          color: kPrimaryColor,
                        ),
                        Text(
                          AppLocalizations.of(context)!.addItemsToOffer,
                          style: const TextStyle(color: kPrimaryColor),
                        )
                      ],
                    ))
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
                      addOffer();
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add,
                          color: kPrimaryColor,
                        ),
                        Text(
                          AppLocalizations.of(context)!.addOffer,
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
        onPressed: createOfferDialog,
        label: Row(
          children: [
            const Icon(Icons.add),
            Text(AppLocalizations.of(context)!.newOffer),
          ],
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.offersTitle,
                  style: const TextStyle(fontSize: 32),
                ),
                IconButton(
                    onPressed: () => {ref.read(offersProvider).getOffers()},
                    icon: const Icon(
                      Icons.refresh,
                      color: kPrimaryColor,
                      size: 32,
                    )),
              ],
            ),
          ),
          Consumer(builder: (context, ref, child) {
            final offerProvider = ref.watch(offersProvider);
            return offerProvider.offers.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: offerProvider.offers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return OfferContainer(
                          offer: offerProvider.offers[index],
                        );
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Center(
                        child:
                            Text(AppLocalizations.of(context)!.noOfferInfo)));
          })
        ],
      ),
    );
  }
}
