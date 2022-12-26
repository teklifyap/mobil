import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:teklifyap/app_data.dart';
import 'package:teklifyap/constants.dart';
import 'package:teklifyap/services/api/api_endpoints.dart';
import 'package:teklifyap/services/models/item.dart';
import 'package:teklifyap/services/models/offer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OfferActions {
  Future<bool> createOffer(
    Offer offer,
  ) async {
    Map<String, dynamic> requestPayload = {
      "title": offer.title,
      "receiverName": offer.receiverName,
      "userName": offer.userName,
      "profitRate": offer.profitRate,
      "items": offer.items,
    };

    Response res = await post(Uri.parse(ApiEndpoints.offerUrl),
        body: jsonEncode(requestPayload),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
        });

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          "something went wrong while creating offer, response body: \n${res.body}");
    }
  }

  Future<Offer> getOffer(int offerID) async {
    Response res = await get(
      Uri.parse(
        '${ApiEndpoints.offerUrl}/$offerID',
      ),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
      },
    );

    if (res.statusCode == 200) {
      return Offer.fromJson(jsonDecode(utf8.decode(res.bodyBytes))["data"]);
    } else {
      throw Exception(
          "something went wrong while getting offer details, response body: \n${res.body}");
    }
  }

  Future<bool> updateOffer(Offer offer) async {
    Map<String, dynamic> requestPayload = {
      "title": offer.title,
      "receiverName": offer.receiverName,
      "userName": offer.userName,
      "profitRate": offer.profitRate,
    };

    Response res = await put(
      Uri.parse('${ApiEndpoints.offerUrl}/${offer.id}'),
      body: jsonEncode(requestPayload),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
      },
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'something went wrong while updating item: ${offer.id}, response body: \n${res.body}');
    }
  }

  Future<bool> deleteOffer(int offerID) async {
    Response res = await delete(
      Uri.parse('${ApiEndpoints.offerUrl}/$offerID'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
      },
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'something went wrong while deleting item: $offerID, response body: \n${res.body}');
    }
  }

  Future<bool> changeOfferStatus(int offerID) async {
    Response res = await put(
      Uri.parse('${ApiEndpoints.offerUrl}/status/$offerID'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
      },
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'something went wrong while changing offer status: $offerID, response body: \n${res.body}');
    }
  }

  Future<List<Offer>> getAllOffers() async {
    List<Offer> allOffers = [];
    Response res = await get(Uri.parse(ApiEndpoints.offerUrl), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
      HttpHeaders.contentTypeHeader: "application/json",
    });

    if (res.statusCode == 200) {
      List<dynamic> offers = jsonDecode(utf8.decode(res.bodyBytes))["data"];
      for (var offer in offers) {
        allOffers.add(await getOffer(offer["id"]));
      }
      return allOffers;
    } else {
      throw Exception(
          "something went wrong while getting all offers, response body: \n${res.body}");
    }
  }

  Future<bool> addItemToOffer(Offer offer, Item item) async {
    Response res = await post(
        Uri.parse('${ApiEndpoints.offerUrl}/item?offer=${offer.id}'),
        body: jsonEncode(item),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
          HttpHeaders.contentTypeHeader: "application/json",
        });

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          "something went wrong while adding item to offer: ${offer.id}, ${offer.title}. response body: \n${res.body}");
    }
  }

  Future<bool> deleteItemFromOffer(Offer offer, int itemID) async {
    Response res = await delete(
      Uri.parse('${ApiEndpoints.offerUrl}/item/$itemID?offer=${offer.id}'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
      },
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'something went wrong while deleting item: $itemID from offer: ${offer.id}, ${offer.title}. response body: \n${res.body}');
    }
  }

  Future<bool> exportOffer(BuildContext context, Offer offer) async {
    Response res = await get(
        Uri.parse('${ApiEndpoints.offerUrl}/export/${offer.id}'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
        });

    if (res.statusCode == 200) {
      if (context.mounted) {
        final offerExportedAlert = SnackBar(
            backgroundColor: kSecondaryColor,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.done,
                    color: kPrimaryColor,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.offerExported,
                  style: const TextStyle(color: kPrimaryColor),
                )
              ],
            ));
        ScaffoldMessenger.of(context).showSnackBar(offerExportedAlert);
      }

      return true;
    } else {
      if (context.mounted) {
        final offerExportedAlert = SnackBar(
            backgroundColor: kSecondaryColor,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.done,
                    color: kPrimaryColor,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.offerCouldNotExported,
                  style: const TextStyle(color: kPrimaryColor),
                )
              ],
            ));
        ScaffoldMessenger.of(context).showSnackBar(offerExportedAlert);
      }
      throw Exception(
          'something went wrong while exporting offer: ${offer.id}, ${offer.title}. response body: \n${res.body}');
    }
  }
}
