import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/constants.dart';
import 'package:teklifyap/provider/offer_provider.dart';
import 'package:teklifyap/services/api/offer_actions.dart';
import 'package:teklifyap/services/models/item.dart';
import 'package:teklifyap/services/models/offer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemContainerForOffer extends HookConsumerWidget {
  const ItemContainerForOffer(this.item, this.offer, {Key? key})
      : super(key: key);

  final Item item;
  final Offer offer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text('${item.name}'),
      subtitle: Text(
          '${AppLocalizations.of(context)!.profitRate}: ${offer.profitRate}\n${AppLocalizations.of(context)!.itemQuantity}: ${item.quantity}\n${AppLocalizations.of(context)!.itemValue}: ${item.value}\n= ${(offer.profitRate!) * (item.quantity!) * (item.value!)}'),
      trailing: IconButton(
        onPressed: () {
          OfferActions.deleteItemFromOffer(offer, item.id!);
          ref.read(offersProvider).getOffers();
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.delete,
          color: kPrimaryColor,
        ),
      ),
    );
  }
}
