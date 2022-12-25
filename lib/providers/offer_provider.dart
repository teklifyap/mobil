import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/services/api/offer_actions.dart';
import 'package:teklifyap/services/models/offer.dart';

class OfferProvider extends StateNotifier<List<Offer>> {
  OfferProvider() : super([]);

  void getOffers() async {
    state = await OfferActions().getAllOffers();
    state.sort(
      (a, b) => b.id!.compareTo(a.id!),
    );
  }
}

final offersProvider =
    StateNotifierProvider<OfferProvider, List<Offer>>((ref) => OfferProvider());
