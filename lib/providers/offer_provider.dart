import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/services/api/offer_actions.dart';
import 'package:teklifyap/services/models/offer.dart';

class OfferProvider extends ChangeNotifier {
  List<Offer> offers = [];

  void getOffers() async {
    offers = await OfferActions.getAllOffers();
    offers = List.from(offers.reversed);
    notifyListeners();
  }
}

final offersProvider = ChangeNotifierProvider((ref) => OfferProvider());
