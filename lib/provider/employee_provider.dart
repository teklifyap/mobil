import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/services/api/employee_actions.dart';
import 'package:teklifyap/services/models/employee.dart';

class EmployeeProvider extends ChangeNotifier {
  List<Employee> _employees = [];

  List<Employee> get employees => _employees;

  void getEmployees() async {
    _employees = await EmployeeActions.getAllEmployees();
    notifyListeners();
  }
}

final employeesProvider = ChangeNotifierProvider((ref) => EmployeeProvider());
