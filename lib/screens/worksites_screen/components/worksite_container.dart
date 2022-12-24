import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/constants.dart';
import 'package:teklifyap/providers/employee_provider.dart';
import 'package:teklifyap/providers/offer_provider.dart';
import 'package:teklifyap/providers/worksite_provider.dart';
import 'package:teklifyap/screens/worksites_screen/components/employee_container_for_worksite.dart';
import 'package:teklifyap/services/api/worksite_actions.dart';
import 'package:teklifyap/services/models/employee.dart';
import 'package:teklifyap/services/models/offer.dart';
import 'package:teklifyap/services/models/worksite.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorksiteContainer extends HookConsumerWidget {
  const WorksiteContainer({Key? key, required this.worksite}) : super(key: key);

  final Worksite worksite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Employee> selectedEmployees = [];
    final employeeProvider = [...ref.read(employeesProvider).employees];

    void deleteOffer(Worksite worksite) async {
      await WorksiteActions.deleteWorksite(worksite.id!);
      ref.read(worksitesProvider).getWorksites();
    }

    Future addEmployeesToOffer(List<Employee> selectedEmployees) async {
      for (var employee in selectedEmployees) {
        await WorksiteActions.employeeManagingForWorksite(
            "add", worksite.id!, employee.id!);
      }
      ref.read(worksitesProvider).getWorksites();
      if (context.mounted) Navigator.pop(context);
    }

    Future addEmployeesToOfferDialog() async {
      selectedEmployees = [];
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.worksiteAddEmployee),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: employeeProvider.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (worksite.employees!.indexWhere((element) =>
                              element.id == employeeProvider[index].id) !=
                          -1) {
                        return null;
                      } else if (selectedEmployees.length ==
                          employeeProvider.length) {
                        return Text(AppLocalizations.of(context)!
                            .worksiteAllEmployeesAdded);
                      } else {
                        return HookBuilder(builder: (BuildContext context) {
                          final isSelected = useState(false);
                          return ListTile(
                            onTap: () {
                              if (isSelected.value) {
                                isSelected.value = false;
                                selectedEmployees
                                    .remove(employeeProvider[index]);
                              } else {
                                selectedEmployees.add(employeeProvider[index]);
                                isSelected.value = true;
                              }
                            },
                            title: Text(
                                '${employeeProvider[index].name} ${employeeProvider[index].surname}'),
                            trailing: isSelected.value
                                ? Text(
                                    AppLocalizations.of(context)!.worksiteAdded)
                                : Text(AppLocalizations.of(context)!
                                    .worksiteClickToAdd),
                          );
                        });
                      }
                    },
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () async {
                            await addEmployeesToOffer(selectedEmployees);
                            if (context.mounted) Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.done,
                            color: kPrimaryColor,
                          ))
                    ],
                  )
                ],
              ));
    }

    Future showEmployeesOfWorksite(List<Employee> employees) async {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.employees),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  content: employees.isNotEmpty
                      ? SizedBox(
                          width: double.maxFinite,
                          child: ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(
                              thickness: 1.2,
                            ),
                            shrinkWrap: true,
                            itemCount: employees.length,
                            itemBuilder: (BuildContext context, int index) {
                              return EmployeeContainerForWorksite(
                                  worksite, employees[index]);
                            },
                          ),
                        )
                      : Text(AppLocalizations.of(context)!.worksiteNoEmployee),
                  actions: [
                    worksite.employees!.length != employeeProvider.length
                        ? TextButton(
                            onPressed: addEmployeesToOfferDialog,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: kPrimaryColor,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.employeeAdd,
                                  style: const TextStyle(color: kPrimaryColor),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.only(right: 16.0, bottom: 4.0),
                            child: Text(AppLocalizations.of(context)!
                                .worksiteAllEmployeesAdded),
                          )
                  ]));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        collapsedBackgroundColor: kPrimaryColor,
        collapsedTextColor: Colors.white,
        textColor: kPrimaryColor,
        collapsedIconColor: Colors.white,
        iconColor: kPrimaryColor,
        title: Text(
          worksite.name!,
        ),
        subtitle: Text(
          worksite.offerName!,
        ),
        leading: const Icon(Icons.apartment),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // IconButton(
            //   onPressed: () => editOffer(),
            //   icon: const Icon(Icons.edit),
            // ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => deleteOffer(worksite),
            ),
          ],
        ),
        children: [
          ListTile(
            title:
                Text('${AppLocalizations.of(context)!.name}: ${worksite.name}'),
          ),
          ListTile(
            title: Text(
                '${AppLocalizations.of(context)!.offerUsername}: ${worksite.userName}'),
          ),
          ListTile(
            title: Text(
                '${AppLocalizations.of(context)!.date}: ${worksite.date?.substring(0, 10)}'),
          ),
          ListTile(
              onTap: () {
                ref.read(offersProvider).getOffers();
                debugPrint(worksite.toString());
                Offer offer = ref.read(offersProvider).offers.firstWhere(
                      (element) => element.title == worksite.offerName,
                    );
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0))),
                        content: SingleChildScrollView(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text(
                                  '${AppLocalizations.of(context)!.offerTitle}: ${offer.title}'),
                            ),
                            ListTile(
                              title: Text(
                                  '${AppLocalizations.of(context)!.offerUsername}: ${offer.userName}'),
                            ),
                            ListTile(
                              title: Text(
                                  '${AppLocalizations.of(context)!.offerReceiver}: ${offer.receiverName}'),
                            ),
                            ListTile(
                              title: Text(
                                  '${AppLocalizations.of(context)!.date}: ${offer.date?.substring(0, 10)}'),
                            ),
                            ListTile(
                              title: Text(
                                  '${AppLocalizations.of(context)!.offerStatus}: ${offer.status ? AppLocalizations.of(context)!.confirmed : AppLocalizations.of(context)!.notConfirmed}'),
                            ),
                            ListTile(
                                title: Text(
                                    '${AppLocalizations.of(context)!.profitRate}: ${offer.profitRate!}')),
                          ],
                        )),
                      );
                    });
              },
              subtitle: Text(
                  AppLocalizations.of(context)!.offerClickToSeeDetails,
                  style: const TextStyle(fontSize: 12, color: kSecondaryColor)),
              title: Text(
                  '${AppLocalizations.of(context)!.worksiteOffer}: ${worksite.offerName}')),
          ListTile(
              title: Text(
                  '${AppLocalizations.of(context)!.worksiteAddress}: ${worksite.address}')),
          ListTile(
              title: Row(
                children: [
                  Text(AppLocalizations.of(context)!.worksiteSeeEmployees),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.remove_red_eye,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
              onTap: () => showEmployeesOfWorksite(worksite.employees!)),
          ListTile(
            title: Row(
              children: [
                Text(AppLocalizations.of(context)!.worksiteSeeLocation),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.map,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
            onTap: () async {
              String url =
                  'https://www.google.com/maps/search/?api=1&query=${worksite.locationX},${worksite.locationY}';
              await canLaunchUrlString(url)
                  ? await launchUrlString(url)
                  : throw 'could not launch ${worksite.name}';
            },
          )
        ],
      ),
    );
  }
}
