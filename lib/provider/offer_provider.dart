import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/services/api/offer_actions.dart';
import 'package:teklifyap/services/models/offer.dart';

class OfferProvider extends ChangeNotifier {
  List<Offer> _offers = [];

  List<Offer> get offers => _offers;

  void getOffers() async {
    _offers = await OfferActions.getAllOffers();
    notifyListeners();
  }
}

final offersProvider = ChangeNotifierProvider((ref) => OfferProvider());
