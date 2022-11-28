import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:teklifyap/app_data.dart';
import 'package:teklifyap/services/api/api_endpoints.dart';
import 'package:teklifyap/services/models/offer.dart';

class OfferActions {
  static Future<bool> createOffer(
      String title,
      String receiverName,
      String userName,
      double profitRate,
      List<Map<String, dynamic>> items) async {
    Map<String, dynamic> requestPayload = {
      "title": title,
      "receiverName": receiverName,
      "userName": userName,
      "profitRate": profitRate,
      "items": items,
    };

    Response res = await post(Uri.parse(ApiEndpoints.forOfferUrl),
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

  static Future<Offer> getOffer(int offerID) async {
    Response res = await get(
      Uri.parse(
        '${ApiEndpoints.forOfferUrl}/$offerID',
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

  static Future<bool> updateOffer(Offer offer) async {
    Map<String, dynamic> requestPayload = {
      "title": offer.title,
      "receiverName": offer.receiverName,
      "userName": offer.userName,
      "profitRate": offer.profitRate,
    };

    Response res = await put(
      Uri.parse('${ApiEndpoints.forOfferUrl}/${offer.id}'),
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

  static Future<bool> deleteOffer(int offerID) async {
    Response res = await delete(
      Uri.parse('${ApiEndpoints.forOfferUrl}/$offerID'),
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

  static Future<bool> changeOfferStatus(int offerID) async {
    Response res = await put(
      Uri.parse('${ApiEndpoints.forOfferUrl}/status/$offerID'),
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

  static Future<List<Offer>> getAllOffers() async {
    List<Offer> allOffers = [];
    Response res = await get(Uri.parse(ApiEndpoints.forOfferUrl), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
      HttpHeaders.contentTypeHeader: "application/json",
    });

    if (res.statusCode == 200) {
      List<dynamic> offers = jsonDecode(utf8.decode(res.bodyBytes))["data"];
      for (var offer in offers) {
        allOffers.add(await OfferActions.getOffer(offer["id"]));
      }
      return allOffers;
    } else {
      throw Exception(
          "something went wrong while getting all offers, response body: \n${res.body}");
    }
  }

  static Future<bool> addItemToOffer(
      Offer offer, Map<String, dynamic> item) async {
    Response res = await post(
        Uri.parse('${ApiEndpoints.forOfferUrl}/item?offer=${offer.id}'),
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

  static Future<bool> deleteItemFromOffer(Offer offer, int itemID) async {
    Response res = await delete(
      Uri.parse('${ApiEndpoints.forOfferUrl}/item/$itemID?offer=${offer.id}'),
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
}
