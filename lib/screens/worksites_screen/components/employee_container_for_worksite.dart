import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/constants.dart';
import 'package:teklifyap/providers/worksite_provider.dart';
import 'package:teklifyap/services/api/worksite_actions.dart';
import 'package:teklifyap/services/models/employee.dart';
import 'package:teklifyap/services/models/worksite.dart';

class EmployeeContainerForWorksite extends ConsumerWidget {
  const EmployeeContainerForWorksite(this.worksite, this.employee, {Key? key})
      : super(key: key);

  final Worksite worksite;
  final Employee employee;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text('${employee.name} ${employee.surname}'),
      trailing: IconButton(
        onPressed: () {
          WorksiteActions().employeeManagingForWorksite(
              "delete", worksite.id!, employee.id!);
          ref.read(worksitesProvider.notifier).getWorksites();
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.remove,
          color: kPrimaryColor,
        ),
      ),
    );
  }
}
