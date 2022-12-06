import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/constants.dart';
import 'package:teklifyap/provider/employee_provider.dart';
import 'package:teklifyap/screens/storage_screen/components/input_field.dart';
import 'package:teklifyap/services/api/employee_actions.dart';
import 'package:teklifyap/services/models/employee.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmployeeContainer extends HookConsumerWidget {
  const EmployeeContainer({Key? key, required this.employee}) : super(key: key);

  final Employee employee;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeNameController = useTextEditingController();
    final employeeSurnameController = useTextEditingController();

    setEditInputFields() {
      employeeNameController.text = '${employee.name}';
      employeeSurnameController.text = '${employee.surname}';
    }

    void deleteEmployee(Employee employee) async {
      await EmployeeActions.deleteEmployee(employee.id!);
      ref.read(employeesProvider).getEmployees();
    }

    void updateEmployee(Employee employee) async {
      employee.name = employeeNameController.text;
      employee.surname = employeeSurnameController.text;
      await EmployeeActions.updateEmployee(employee);
      ref.read(employeesProvider).getEmployees();
    }

    Future editEmployee() async {
      setEditInputFields();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.editEmployee),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomInputField(
                  controller: employeeNameController,
                  labelText: AppLocalizations.of(context)!.employeeName),
              CustomInputField(
                controller: employeeSurnameController,
                labelText: AppLocalizations.of(context)!.employeeSurname,
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    updateEmployee(employee);
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.save,
                        color: kPrimaryColor,
                      ),
                      Text(
                        AppLocalizations.of(context)!.employeeSave,
                        style: const TextStyle(color: kPrimaryColor),
                      )
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    deleteEmployee(employee);
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.delete,
                        color: kPrimaryColor,
                      ),
                      Text(
                        AppLocalizations.of(context)!.employeeDelete,
                        style: const TextStyle(color: kPrimaryColor),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Card(
        color: kPrimaryColor,
        child: ListTile(
          onTap: editEmployee,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${employee.name} ${employee.surname}',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
