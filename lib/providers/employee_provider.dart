import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/services/api/employee_actions.dart';
import 'package:teklifyap/services/models/employee.dart';

class EmployeeProvider extends StateNotifier<List<Employee>> {
  EmployeeProvider() : super([]);

  void getEmployees() async {
    state = await EmployeeActions().getAllEmployees();
    state.sort(
      (a, b) => b.id!.compareTo(a.id!),
    );
  }
}

final employeesProvider =
    StateNotifierProvider<EmployeeProvider, List<Employee>>(
        (ref) => EmployeeProvider());
