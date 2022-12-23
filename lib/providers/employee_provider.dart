import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/services/api/employee_actions.dart';
import 'package:teklifyap/services/models/employee.dart';

class EmployeeProvider extends ChangeNotifier {
  List<Employee> employees = [];

  void getEmployees() async {
    employees = await EmployeeActions.getAllEmployees();
    employees = List.from(employees.reversed);
    notifyListeners();
  }
}

final employeesProvider = ChangeNotifierProvider((ref) => EmployeeProvider());
