import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:teklifyap/services/api/api_endpoints.dart';
import 'package:teklifyap/services/models/employee.dart';
import 'package:teklifyap/app_data.dart';

class EmployeeActions {
  Future<bool> newEmployee(Employee employee) async {
    Map<String, dynamic> requestPayload = {
      "name": employee.name,
      "surname": employee.surname,
      "salary": employee.salary,
    };

    Response res = await post(
      Uri.parse(ApiEndpoints.employeeUrl),
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

  Future<List<Employee>> getAllEmployees() async {
    List<Employee> allEmployees = [];
    Response res = await get(Uri.parse(ApiEndpoints.employeeUrl), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${AppData.authToken}',
      HttpHeaders.contentTypeHeader: "application/json",
    });

    if (res.statusCode == 200) {
      List<dynamic> employees = jsonDecode(utf8.decode(res.bodyBytes))["data"];
      for (var employee in employees) {
        allEmployees.add(await getEmployee(employee["id"]));
      }
      return allEmployees;
    } else {
      throw Exception(
          "something went wrong while getting all items, response body: \n${res.body}");
    }
  }

  Future<Employee> getEmployee(int employeeID) async {
    Response res = await get(
        Uri.parse("${ApiEndpoints.employeeUrl}/$employeeID"),
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

  Future<bool> updateEmployee(Employee employee) async {
    Map<String, dynamic> requestPayload = {
      "name": employee.name,
      "surname": employee.surname
    };

    Response res = await put(
      Uri.parse('${ApiEndpoints.employeeUrl}/${employee.id}'),
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

  Future<bool> deleteEmployee(int employeeID) async {
    Response res = await delete(
      Uri.parse('${ApiEndpoints.employeeUrl}/$employeeID'),
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
