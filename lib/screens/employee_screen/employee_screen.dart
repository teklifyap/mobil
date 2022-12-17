import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teklifyap/provider/employee_provider.dart';
import 'package:teklifyap/screens/employee_screen/components/employee_container.dart';
import 'package:teklifyap/screens/storage_screen/components/input_field.dart';
import 'package:teklifyap/services/api/employee_actions.dart';
import 'package:teklifyap/services/models/employee.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EmployeeScreen extends HookConsumerWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeNameController = useTextEditingController();
    final employeeSurnameController = useTextEditingController();
    final employeeSalaryController = useTextEditingController();
    final width = MediaQuery.of(context).size.width;

    void newEmployee(Employee employee) async {
      await EmployeeActions.newEmployee(employee);
      ref.read(employeesProvider).getEmployees();
      employeeNameController.clear();
      employeeSurnameController.clear();
      employeeSalaryController.clear();
    }

    Future newEmployeeDialog() async {
      final formKey = GlobalKey<FormState>();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.employeeNew),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomInputField(
                      controller: employeeNameController,
                      labelText: AppLocalizations.of(context)!.employeeName),
                  CustomInputField(
                      controller: employeeSurnameController,
                      labelText: AppLocalizations.of(context)!.employeeSurname),
                  CustomInputField(
                      controller: employeeSalaryController,
                      labelText: AppLocalizations.of(context)!.employeeSalary),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        newEmployee(Employee(
                            name: employeeNameController.text,
                            surname: employeeSurnameController.text,
                            salary: employeeSalaryController.text));
                        Navigator.pop(context);
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add,
                          color: kPrimaryColor,
                        ),
                        Text(
                          AppLocalizations.of(context)!.employeeAdd,
                          style: const TextStyle(color: kPrimaryColor),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: newEmployeeDialog,
        label: Row(
          children: [
            const Icon(Icons.add),
            Text(AppLocalizations.of(context)!.employeeNew),
          ],
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(children: [
        Padding(
            padding: const EdgeInsets.only(top: 60, left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.employees,
                  style: const TextStyle(fontSize: 32),
                ),
                IconButton(
                    onPressed: () =>
                        {ref.read(employeesProvider).getEmployees()},
                    icon: const Icon(
                      Icons.refresh,
                      color: kPrimaryColor,
                      size: 32,
                    )),
              ],
            )),
        Consumer(builder: (context, ref, child) {
          final employeeProvider = ref.watch(employeesProvider);
          return employeeProvider.employees.isNotEmpty
              ? Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            kIsWeb ? (width <= 1000 ? width ~/ 150 : 8) : 3),
                    itemCount: employeeProvider.employees.length,
                    itemBuilder: (context, index) {
                      return EmployeeContainer(
                          employee: employeeProvider.employees[index]);
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: Center(
                      child: Text(AppLocalizations.of(context)!.noEmployee)));
        })
      ]),
    );
  }
}
