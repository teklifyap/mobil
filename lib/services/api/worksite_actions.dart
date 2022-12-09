import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

import 'package:teklifyap/app_data.dart';
import 'package:teklifyap/services/api/api_endpoints.dart';
import 'package:teklifyap/services/models/worksite.dart';

class WorksiteActions {
  static Future<bool> createWorksite(Worksite worksite) async {
    Map<String, dynamic> requestPayload = {
      "name": worksite.name,
      "offerId": worksite.offerID,
      "userName": worksite.userName,
      "address": worksite.address,
      "locationX": worksite.locationX,
      "locationY": worksite.locationY
    };

    Response res = await post(Uri.parse(ApiEndpoints.worksiteUrl),
        body: jsonEncode(requestPayload),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
        });

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          "something went wrong while creating worksite, response body: \n${res.body}");
    }
  }

  static Future<List<Worksite>> getAllWorksites() async {
    List<Worksite> allWorksites = [];
    Response res = await get(Uri.parse(ApiEndpoints.worksiteUrl), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
      HttpHeaders.contentTypeHeader: "application/json",
    });

    if (res.statusCode == 200) {
      List<dynamic> worksite = jsonDecode(utf8.decode(res.bodyBytes))["data"];
      for (var worksite in worksite) {
        allWorksites.add(await WorksiteActions.getWorksite(worksite["id"]));
      }
      return allWorksites;
    } else {
      throw Exception(
          "something went wrong while getting all worksites, response body: \n${res.body}");
    }
  }

  static Future<Worksite> getWorksite(int worksiteID) async {
    Response res = await get(
      Uri.parse(
        '${ApiEndpoints.worksiteUrl}/$worksiteID',
      ),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
      },
    );

    if (res.statusCode == 200) {
      return Worksite.fromJson(jsonDecode(utf8.decode(res.bodyBytes))["data"]);
    } else {
      throw Exception(
          "something went wrong while getting worksite details, response body: \n${res.body}");
    }
  }

  static Future<bool> deleteWorksite(int worksiteID) async {
    Response res = await delete(
      Uri.parse('${ApiEndpoints.worksiteUrl}/$worksiteID'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
      },
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'something went wrong while deleting worksite: $worksiteID, response body: \n${res.body}');
    }
  }

  static Future<bool> employeeManagingForWorksite(
      String process, int worksiteID, int employeeID) async {
    Response res;
    if (process == "add") {
      res = await put(
        Uri.parse(
            '${ApiEndpoints.worksiteUrl}/$worksiteID/employee/$employeeID'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
        },
      );
    } else {
      res = await delete(
        Uri.parse(
            '${ApiEndpoints.worksiteUrl}/$worksiteID/employee/$employeeID'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
        },
      );
    }

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'something went wrong while adding employee:$employeeID to worksite:$worksiteID, response body: \n${res.body}');
    }
  }
}
