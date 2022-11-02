import 'package:flutter/material.dart';
import 'package:teklifyap/screens/offers_screen/components/offer_container.dart';
import 'package:teklifyap/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({Key? key}) : super(key: key);

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  List<OfferContainer> offers = [
    OfferContainer(
      offerTitle: "offer title",
      offerDate: "28/10/2022",
      onListTileTap: () => debugPrint("list tile tap func"),
      onDelete: () => debugPrint("delete func"),
    )
  ];

  void removeOffer({required List offers, required int index}) {
    offers.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {},
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
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                AppLocalizations.of(context)!.offersTitle,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          offers.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: offers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return offers[index];
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: Center(
                      child: Text(AppLocalizations.of(context)!.noOfferInfo)))
        ],
      ),
    );
  }
}
