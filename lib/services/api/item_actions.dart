import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

import 'package:teklifyap/app_data.dart';
import 'package:teklifyap/services/api/api_endpoints.dart';
import 'package:teklifyap/services/models/item.dart';

class ItemActions {
  static Future<bool> createItem(Item item) async {
    Map<String, dynamic> requestPayload = {
      "name": item.name,
      "value": item.value,
      "unit": item.unit?.toUpperCase(),
    };

    Response res = await post(
      Uri.parse(ApiEndpoints.forItemUrl),
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
          "something went wrong while creating item, response body: \n${res.body}");
    }
  }

  static Future<bool> deleteItem(int itemID) async {
    Response res = await delete(
      Uri.parse('${ApiEndpoints.forItemUrl}/$itemID'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
      },
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'something went wrong while deleting item: $itemID, response body: \n${res.body}');
    }
  }

  static Future<bool> updateItem(Item item) async {
    Map<String, dynamic> requestPayload = {
      "name": item.name,
      "value": item.value,
    };

    Response res = await put(
      Uri.parse('${ApiEndpoints.forItemUrl}/${item.id}'),
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
          'something went wrong while updating item: ${item.id}, response body: \n${res.body}');
    }
  }

  static Future<List<Item>> getAllItems() async {
    List<Item> allItems = [];
    Response res = await get(Uri.parse(ApiEndpoints.forItemUrl), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
      HttpHeaders.contentTypeHeader: "application/json",
    });

    if (res.statusCode == 200) {
      List<dynamic> items = jsonDecode(utf8.decode(res.bodyBytes))["data"];
      for (var item in items) {
        allItems.add(await ItemActions.getItem(item["id"]));
      }
      return allItems;
    } else {
      throw Exception(
          "something went wrong while getting all items, response body: \n${res.body}");
    }
  }

  static Future<Item> getItem(int itemID) async {
    Response res =
        await get(Uri.parse("${ApiEndpoints.forItemUrl}/$itemID"), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
      HttpHeaders.contentTypeHeader: "application/json",
    });

    if (res.statusCode == 200) {
      return Item.fromJson(jsonDecode(utf8.decode(res.bodyBytes))["data"]);
    } else {
      throw Exception(
          "something went wrong while getting item details, response body: \n${res.body}");
    }
  }
}
