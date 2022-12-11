import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/constants.dart';
import 'package:teklifyap/provider/item_provider.dart';
import 'package:teklifyap/provider/offer_provider.dart';
import 'package:teklifyap/screens/offers_screen/components/item_container_for_offer.dart';
import 'package:teklifyap/screens/storage_screen/components/input_field.dart';
import 'package:teklifyap/services/api/offer_actions.dart';
import 'package:teklifyap/services/models/item.dart';
import 'package:teklifyap/services/models/offer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OfferContainer extends HookConsumerWidget {
  const OfferContainer({
    Key? key,
    required this.offer,
  }) : super(key: key);

  final Offer offer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusSwitch = useState(false);
    statusSwitch.value = offer.status;
    final offerTitleController = useTextEditingController();
    final userNameController = useTextEditingController();
    final receiverNameController = useTextEditingController();
    final profitRateController = useTextEditingController();
    List<TextEditingController> selectedItemsQuantities = [];
    List<int> selectedItemIDS = [];
    List<Item> selectedItems = [];
    var itemProvider = [...ref.read(itemsProvider).items];
    itemProvider.removeWhere((element) => element.value == 0);

    setEditInputFields() {
      offerTitleController.text = offer.title!;
      userNameController.text = offer.userName!;
      receiverNameController.text = offer.receiverName!;
      profitRateController.text = '${offer.profitRate!}';
    }

    Future changeOfferStatus() async {
      await OfferActions.changeOfferStatus(offer.id!);
      ref.read(offersProvider).getOffers();
    }

    Future addItemsToOffer(List<Item> items) async {
      for (var item in items) {
        await OfferActions.addItemToOffer(offer, item);
      }
      ref.read(offersProvider).getOffers();
      if (context.mounted) Navigator.pop(context);
    }

    Future addItemsToOfferDialog() async {
      selectedItemIDS = [];
      selectedItemsQuantities = [];
      selectedItems = [];
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.selectItems),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: itemProvider.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (selectedItemIDS.contains(itemProvider[index].id)) {
                        return null;
                      } else if (selectedItemIDS.length ==
                          itemProvider.length) {
                        return Text(
                            AppLocalizations.of(context)!.youAddedAllItems);
                      } else {
                        List<int> offerIds = [];
                        for (var element in offer.items!) {
                          offerIds.add(element.id!);
                        }
                        if (offerIds.contains(itemProvider[index].id)) {
                          return Container();
                        } else {
                          return HookBuilder(
                            builder: (BuildContext context) {
                              final isSelected = useState(false);
                              final quantityController =
                                  useTextEditingController();
                              return ListTile(
                                  onTap: () {
                                    isSelected.value = !isSelected.value;
                                    selectedItemsQuantities
                                        .add(quantityController);
                                    selectedItemIDS
                                        .add(itemProvider[index].id!);
                                  },
                                  title: Text(itemProvider[index].name ?? ""),
                                  trailing: isSelected.value
                                      ? SizedBox(
                                          width: 80,
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
                        }
                      }
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
                            onPressed: () async {
                              selectedItemIDS.asMap().forEach((i, x) {
                                selectedItems.add(Item(
                                    id: x,
                                    quantity: double.parse(
                                        selectedItemsQuantities[i].text)));
                              });
                              await addItemsToOffer(selectedItems);
                              if (context.mounted) Navigator.pop(context);
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

    Future showOfferItems(List<Item> items) async {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.offerItems),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                content: items.isNotEmpty
                    ? SizedBox(
                        width: double.maxFinite,
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                            thickness: 1.2,
                          ),
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ItemContainerForOffer(items[index], offer);
                          },
                        ),
                      )
                    : Text(
                        AppLocalizations.of(context)!.thereIsNoItemInTheOffer),
                actions: [
                  offer.items!.length != itemProvider.length
                      ? TextButton(
                          onPressed: addItemsToOfferDialog,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.add,
                                color: kPrimaryColor,
                              ),
                              Text(
                                AppLocalizations.of(context)!.addItemToOffer,
                                style: const TextStyle(color: kPrimaryColor),
                              ),
                            ],
                          ))
                      : Padding(
                          padding:
                              const EdgeInsets.only(right: 16.0, bottom: 4.0),
                          child: Text(AppLocalizations.of(context)!
                              .offerAlreadyHasAllYourItems),
                        )
                ],
              ));
    }

    void updateOffer(Offer newOffer) async {
      await OfferActions.updateOffer(newOffer);
      ref.read(offersProvider).getOffers();
    }

    Future editOffer() async {
      setEditInputFields();
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.editOffer),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomInputField(
                        labelText: AppLocalizations.of(context)!.offerTitle,
                        controller: offerTitleController),
                    CustomInputField(
                        labelText: AppLocalizations.of(context)!.offerUsername,
                        controller: userNameController),
                    CustomInputField(
                        labelText: AppLocalizations.of(context)!.offerReceiver,
                        controller: receiverNameController),
                    CustomInputField(
                        labelText: AppLocalizations.of(context)!.profitRate,
                        controller: profitRateController)
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          updateOffer(Offer(
                              id: offer.id!,
                              title: offerTitleController.text,
                              userName: userNameController.text,
                              receiverName: receiverNameController.text,
                              profitRate:
                                  double.parse(profitRateController.text)));
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.save,
                              color: kPrimaryColor,
                            ),
                            Text(
                              AppLocalizations.of(context)!.saveOffer,
                              style: const TextStyle(color: kPrimaryColor),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ));
    }

    void deleteOffer(Offer offer) async {
      await OfferActions.deleteOffer(offer.id as int);
      ref.read(offersProvider).getOffers();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        collapsedBackgroundColor: kPrimaryColor,
        collapsedTextColor: Colors.white,
        textColor: kPrimaryColor,
        collapsedIconColor: Colors.white,
        iconColor: kPrimaryColor,
        title: Text(
          offer.title!,
        ),
        subtitle: Text(
          offer.receiverName!,
        ),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(offer.status ? Icons.done : Icons.cancel),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => OfferActions.exportOffer(context, offer),
              icon: const Icon(Icons.print),
            ),
            IconButton(
              onPressed: () => editOffer(),
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => deleteOffer(offer),
            ),
          ],
        ),
        children: [
          ListTile(
            title: Text(
                '${AppLocalizations.of(context)!.offerTitle}: ${offer.title}'),
          ),
          ListTile(
            title: Text(
                '${AppLocalizations.of(context)!.offerUsername}: ${offer.userName}'),
          ),
          ListTile(
            title: Text(
                '${AppLocalizations.of(context)!.offerReceiver}: ${offer.receiverName}'),
          ),
          ListTile(
            title: Text(
                '${AppLocalizations.of(context)!.date}: ${offer.date?.substring(0, 10)}'),
          ),
          ListTile(
            trailing: Switch.adaptive(
              value: statusSwitch.value,
              onChanged: (bool value) async {
                await changeOfferStatus();
                statusSwitch.value = value;
              },
              activeColor: kPrimaryColor,
            ),
            title: Text(
                '${AppLocalizations.of(context)!.offerStatus}: ${offer.status ? AppLocalizations.of(context)!.confirmed : AppLocalizations.of(context)!.notConfirmed}'),
          ),
          ListTile(
              title: Text(
                  '${AppLocalizations.of(context)!.profitRate}: ${offer.profitRate!}')),
          ListTile(
            title: Row(
              children: [
                Text(AppLocalizations.of(context)!.seeOfferItems),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.remove_red_eye,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
            onTap: () => showOfferItems(offer.items!),
          )
        ],
      ),
    );
  }
}
