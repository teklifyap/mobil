import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/constants.dart';
import 'package:teklifyap/custom_widgets/custom_dialog.dart';
import 'package:teklifyap/providers/employee_provider.dart';
import 'package:teklifyap/custom_widgets/input_field.dart';
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

    setControllers() {
      employeeNameController.text = employee.name ?? "";
      employeeSurnameController.text = employee.surname ?? "";
    }

    void deleteEmployee(Employee employee) async {
      await EmployeeActions().deleteEmployee(employee.id!);
      ref.read(employeesProvider.notifier).getEmployees();
    }

    void updateEmployee(Employee employee) async {
      employee.name = employeeNameController.text;
      employee.surname = employeeSurnameController.text;
      await EmployeeActions().updateEmployee(employee);
      ref.read(employeesProvider.notifier).getEmployees();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Card(
        color: kPrimaryColor,
        child: ListTile(
          onTap: () {
            setControllers();
            CustomDialogs().basicEditDialog(
                context: context,
                title: AppLocalizations.of(context)!.editEmployee,
                content: [
                  CustomInputField(
                      controller: employeeNameController,
                      labelText: AppLocalizations.of(context)!.employeeName),
                  CustomInputField(
                    controller: employeeSurnameController,
                    labelText: AppLocalizations.of(context)!.employeeSurname,
                  ),
                ],
                leftButtonAction: () {
                  deleteEmployee(employee);
                },
                rightButtonAction: () {
                  updateEmployee(employee);
                },
                leftButtonIcon: Icons.delete,
                rightButtonIcon: Icons.save,
                leftButtonText: AppLocalizations.of(context)!.employeeDelete,
                rightButtonText: AppLocalizations.of(context)!.employeeSave,
                doesRightButtonNeedValidation: true);
          },
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
