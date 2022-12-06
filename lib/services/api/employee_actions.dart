import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:teklifyap/services/api/api_endpoints.dart';
import 'package:teklifyap/services/models/employee.dart';
import 'package:teklifyap/app_data.dart';

class EmployeeActions {
  static Future<bool> newEmployee(Employee employee) async {
    Map<String, dynamic> requestPayload = {
      "name": employee.name,
      "surname": employee.surname,
      "salary": employee.salary,
    };

    Response res = await post(
      Uri.parse(ApiEndpoints.forEmployee),
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
          "something went wrong while adding new employee, response body: \n${res.body}");
    }
  }

  static Future<List<Employee>> getAllEmployees() async {
    List<Employee> allEmployees = [];
    Response res = await get(Uri.parse(ApiEndpoints.forEmployee), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
      HttpHeaders.contentTypeHeader: "application/json",
    });

    if (res.statusCode == 200) {
      List<dynamic> employees = jsonDecode(utf8.decode(res.bodyBytes))["data"];
      for (var employee in employees) {
        allEmployees.add(await EmployeeActions.getEmployee(employee["id"]));
      }
      return allEmployees;
    } else {
      throw Exception(
          "something went wrong while getting all items, response body: \n${res.body}");
    }
  }

  static Future<Employee> getEmployee(int employeeID) async {
    Response res = await get(
        Uri.parse("${ApiEndpoints.forEmployee}/$employeeID"),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
          HttpHeaders.contentTypeHeader: "application/json",
        });

    if (res.statusCode == 200) {
      return Employee.fromJson(jsonDecode(utf8.decode(res.bodyBytes))["data"]);
    } else {
      throw Exception(
          "something went wrong while getting item details, response body: \n${res.body}");
    }
  }

  static Future<bool> updateEmployee(Employee employee) async {
    Map<String, dynamic> requestPayload = {
      "name": employee.name,
      "surname": employee.surname
    };

    Response res = await put(
      Uri.parse('${ApiEndpoints.forEmployee}/${employee.id}'),
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
          'something went wrong while updating item: ${employee.id}, response body: \n${res.body}');
    }
  }

  static Future<bool> deleteEmployee(int employeeID) async {
    Response res = await delete(
      Uri.parse('${ApiEndpoints.forEmployee}/$employeeID'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
      },
    );

    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'something went wrong while deleting item: $employeeID, response body: \n${res.body}');
    }
  }
}
