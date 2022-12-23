import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/custom%20widgets/custom_dialog.dart';
import 'package:teklifyap/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teklifyap/providers/employee_provider.dart';
import 'package:teklifyap/screens/employee_screen/components/employee_container.dart';
import 'package:teklifyap/custom%20widgets/input_field.dart';
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
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CustomDialogs.basicAddOrCreateDialog(
            content: [
              CustomInputField(
                  controller: employeeNameController,
                  labelText: AppLocalizations.of(context)!.employeeName),
              CustomInputField(
                  controller: employeeSurnameController,
                  labelText: AppLocalizations.of(context)!.employeeSurname),
              CustomInputField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputType: TextInputType.number,
                  controller: employeeSalaryController,
                  labelText: AppLocalizations.of(context)!.employeeSalary),
            ],
            title: AppLocalizations.of(context)!.employeeNew,
            actionText: AppLocalizations.of(context)!.employeeAdd,
            actionIcon: Icons.add,
            action: () {
              newEmployee(Employee(
                  name: employeeNameController.text,
                  surname: employeeSurnameController.text,
                  salary: employeeSalaryController.text));
              Navigator.pop(context);
            },
            context: context),
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
