import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:teklifyap/app_data.dart';
import 'package:teklifyap/http/api_endpoints.dart';
import 'package:teklifyap/services/alerts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teklifyap/utils/constants.dart';

class HttpService {
  static String url = "https://teklifyap-api.oguzhanercelik.dev";

  static Future<bool> login(
      BuildContext context, String email, String password) async {
    Map<String, dynamic> requestPayload = {
      "email": email,
      "password": password
    };

    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(
              color: kPrimaryColor,
            ),
          );
        });

    Response res = await post(
      Uri.parse(ApiEndpoints.authUrl),
      body: jsonEncode(requestPayload),
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
    );

    Navigator.pop(context);

    if (res.statusCode == 200) {
      final responseBody = jsonDecode(res.body.toString());
      AppData.authToken = responseBody["data"];
      return true;
    } else if (res.statusCode == 401) {
      if (context.mounted) {
        CustomAlerts.errorOccurredMessage(
            context, AppLocalizations.of(context)!.yourAccountIsNotConfirmed);
      }
      throw Exception("not confirmed, while logging: \n${res.body}");
    } else {
      if (context.mounted) {
        CustomAlerts.errorOccurredMessage(
            context, AppLocalizations.of(context)!.wrongEmailOrPassword);
      }

      throw Exception(
          "something went wrong while logging, response body: \n${res.body}");
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
          "something went wrong while getting profile, response body: \n${res.body}");
    }
  }

  static Future<bool> register(String name, String surname, String email,
      String password, BuildContext context) async {
    Map<String, dynamic> requestPayload = {
      "name": name,
      "surname": surname,
      "email": email,
      "password": password
    };

    Response res = await post(Uri.parse(ApiEndpoints.registerUrl),
        body: jsonEncode(requestPayload),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        });

    if (res.statusCode == 200 && context.mounted) {
      CustomAlerts.errorOccurredMessage(
          context, AppLocalizations.of(context)!.confirmYourAccount);
      return true;
    } else {
      throw Exception(
          "something went wrong while registering, response body: \n${res.body}");
    }
  }

  static Future<bool> itemCreate(
      String name, int value, String unit, BuildContext context) async {
    Map<String, dynamic> requestPayload = {
      "name": name,
      "value": value,
      "unit": unit.toUpperCase(),
    };

    Response res = await post(
      Uri.parse(ApiEndpoints.createItemUrl),
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
}
