import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:teklifyap/app_data.dart';
import 'package:teklifyap/http/api_endpoints.dart';
import 'package:teklifyap/services/alerts.dart';

class HttpService {
  static String url = "https://teklifyap-api.oguzhanercelik.dev";

  static Future<bool> login(
      BuildContext context, String email, String password) async {
    Map<String, dynamic> requestPayload = {
      "email": email,
      "password": password
    };

    Response res = await post(Uri.parse(ApiEndpoints.authUrl),
        body: jsonEncode(requestPayload),
        headers: {"Content-Type": "application/json"});

    if (res.statusCode == 200) {
      final responseBody = jsonDecode(res.body.toString());
      AppData.authToken = responseBody["data"];
      return true;
    } else {
      CustomAlerts.errorOccurredMessage(context, "Wrong email or password!");
      throw Exception("something went wrong while logging: \n${res.body}");
    }
  }

  static Future<bool> getProfile() async {
    Response res = await get(Uri.parse(ApiEndpoints.getProfileUrl), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
      HttpHeaders.contentTypeHeader: "application/json",
    });

    if (res.statusCode == 200) {
      AppData.currentUser = jsonDecode(res.body)["data"];
      return true;
    } else {
      throw Exception(
          "something went wrong while getting profile response body: \n${res.body}");
    }
  }

  static Future<bool> register(
      String name, String surname, String email, String password) async {
    Map<String, dynamic> requestPayload = {
      "name": name,
      "surname": surname,
      "email": email,
      "password": password
    };

    Response res = await post(Uri.parse(ApiEndpoints.registerURL),
        body: jsonEncode(requestPayload),
        headers: {"Content-Type": "application/json"});

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          "something went wrong while registering response body: \n${res.body}");
    }
  }
}
