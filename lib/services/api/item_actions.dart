import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:teklifyap/app_data.dart';
import 'package:teklifyap/services/api/api_endpoints.dart';
import 'package:teklifyap/services/models/item.dart';

class ItemActions {
  static Future<bool> createItem(
      String name, String value, String unit, BuildContext context) async {
    Map<String, dynamic> requestPayload = {
      "name": name,
      "value": double.parse(value),
      "unit": unit.toUpperCase(),
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

  static Future<bool> getAllItems() async {
    AppData.storageItems.clear();
    Response res = await get(Uri.parse(ApiEndpoints.forItemUrl), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
      HttpHeaders.contentTypeHeader: "application/json",
    });

    if (res.statusCode == 200) {
      List<dynamic> items = jsonDecode(res.body)["data"];
      for (var value in items) {
        await ItemActions.getItem(value["id"]);
      }
      return true;
    } else {
      throw Exception(
          "something went wrong while getting all items, response body: \n${res.body}");
    }
  }

  static Future<bool> getItem(int id) async {
    Response res =
        await get(Uri.parse("${ApiEndpoints.forItemUrl}/$id"), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
      HttpHeaders.contentTypeHeader: "application/json",
    });

    if (res.statusCode == 200) {
      AppData.storageItems.add(Item.fromJson(jsonDecode(res.body)["data"]));
      return true;
    } else {
      throw Exception(
          "something went wrong while getting item details, response body: \n${res.body}");
    }
  }
}
