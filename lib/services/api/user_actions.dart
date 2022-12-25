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
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserActions {
  final storage = const FlutterSecureStorage();

  Future<void> storeUserToken(String authToken) async {
    await storage.write(key: "authToken", value: authToken);
  }

  Future<String?> getUserToken() async {
    return await storage.read(key: "authToken");
  }

  Future<void> removeUserToken() async {
    await storage.delete(key: "authToken");
  }

  Future<bool> login(
      BuildContext context, String email, String password) async {
    Map<String, dynamic> requestPayload = {
      "email": email,
      "password": password
    };

    Response res = await post(
      Uri.parse(ApiEndpoints.authUrl),
      body: jsonEncode(requestPayload),
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
    );

    if (res.statusCode == 200) {
      final responseBody = jsonDecode(utf8.decode(res.bodyBytes));
      String token = responseBody["data"];
      AppData.authToken = token;
      storeUserToken(token);
      return true;
    } else if (res.statusCode == 401) {
      if (context.mounted) {
        Navigator.pop(context);
        CustomAlerts.errorOccurredMessage(
            context, AppLocalizations.of(context)!.yourAccountIsNotConfirmed);
      }
      throw Exception("not confirmed, while logging: \n${res.body}");
    } else {
      if (context.mounted) {
        Navigator.pop(context);
        CustomAlerts.errorOccurredMessage(
            context, AppLocalizations.of(context)!.wrongEmailOrPassword);
      }

      throw Exception(
          "something went wrong while logging, response body: \n${res.body}");
    }
  }

  Future<bool> register(String name, String surname, String email,
      String password, BuildContext context) async {
    Map<String, dynamic> requestPayload = {
      "name": name,
      "surname": surname,
      "email": email,
      "password": password
    };

    Response res = await post(Uri.parse('${ApiEndpoints.authUrl}/register'),
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

  Future<User> getUser() async {
    Response res = await get(Uri.parse(ApiEndpoints.profileUrl), headers: {
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

  Future<bool> deleteUser(BuildContext context) async {
    Response res = await delete(Uri.parse(ApiEndpoints.userUrl), headers: {
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

  Future<bool> updateUser(
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
      Uri.parse(ApiEndpoints.profileUrl),
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
