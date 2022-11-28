import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:http/http.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teklifyap/app_data.dart';
import 'package:teklifyap/services/api/api_endpoints.dart';
import 'package:teklifyap/services/alerts.dart';
import 'package:teklifyap/services/models/user.dart';
import 'package:teklifyap/constants.dart';

class UserActions {
  static Future<bool> login(
      BuildContext context, String email, String password) async {
    Map<String, dynamic> requestPayload = {
      "email": email,
      "password": password
    };

    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor)),
          );
        });

    Response res = await post(
      Uri.parse(ApiEndpoints.authUrl),
      body: jsonEncode(requestPayload),
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
    );

    if (context.mounted) {
      Navigator.pop(context);
    }

    if (res.statusCode == 200) {
      final responseBody = jsonDecode(utf8.decode(res.bodyBytes));
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

  static Future<User> getUser() async {
    Response res = await get(Uri.parse(ApiEndpoints.forProfileUrl), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
      HttpHeaders.contentTypeHeader: "application/json",
    });

    if (res.statusCode == 200) {
      return User.fromJson(jsonDecode(utf8.decode(res.bodyBytes))["data"]);
    } else {
      throw Exception(
          "something went wrong while getting profile, response body: \n${res.body}");
    }
  }

  static Future<bool> deleteUser(BuildContext context) async {
    Response res = await delete(Uri.parse(ApiEndpoints.forUserUrl), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
      HttpHeaders.contentTypeHeader: "application/json",
    });
    if (res.statusCode == 200) {
      if (context.mounted) Phoenix.rebirth(context);
      return true;
    } else {
      throw Exception(
          "something went wrong while deleting profile, response body: \n${res.body}");
    }
  }

  static Future<bool> updateUser(
      User updatedUser, String currentPassword, String? newPassword) async {
    Map<String, dynamic> requestPayload = {
      "name": updatedUser.name,
      "surname": updatedUser.surname,
      "email": updatedUser.email,
      "password": currentPassword,
    };

    if (newPassword != "") {
      requestPayload["newPassword"] = newPassword;
    }

    Response res = await put(
      Uri.parse(ApiEndpoints.forProfileUrl),
      body: jsonEncode(requestPayload),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          "something went wrong while updating profile, response body: \n${res.body}");
    }
  }
}
