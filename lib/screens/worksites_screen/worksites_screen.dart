import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teklifyap/constants.dart';
import 'package:teklifyap/provider/offer_provider.dart';
import 'package:teklifyap/provider/user_provider.dart';
import 'package:teklifyap/provider/worksite_provider.dart';
import 'package:teklifyap/screens/storage_screen/components/input_field.dart';
import 'package:teklifyap/screens/worksites_screen/components/worksite_container.dart';
import 'package:teklifyap/services/api/worksite_actions.dart';
import 'package:teklifyap/services/models/worksite.dart';

class WorksitesScreen extends HookConsumerWidget {
  const WorksitesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worksiteNameController = useTextEditingController();
    final worksiteAddressController = useTextEditingController();
    double worksiteLocationX = 40.741895;
    double worksiteLocationY = -73.989308;
    int offerID = 0;

    void newWorksite() async {
      final profile = ref.read(userProvider);
      await WorksiteActions.createWorksite(Worksite(
          name: worksiteNameController.text,
          offerID: offerID,
          userName: '${profile.user!.name} ${profile.user!.surname}',
          address: worksiteAddressController.text,
          locationX: worksiteLocationX,
          locationY: worksiteLocationY));
      ref.read(worksitesProvider).getWorksites();
    }

    Future newWorksiteDialog() async {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.worksiteNew),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          content: HookBuilder(
            builder: (context) {
              ref.read(offersProvider).getOffers();
              final offerProvider = ref.read(offersProvider);
              final offerTitle = useState(offerProvider.offers.first.title);
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomInputField(
                    controller: worksiteNameController,
                    labelText: AppLocalizations.of(context)!.name,
                  ),
                  CustomInputField(
                    controller: worksiteAddressController,
                    labelText: AppLocalizations.of(context)!.worksiteAddress,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(AppLocalizations.of(context)!.worksiteSelectOffer),
                      DropdownButton<String>(
                        value: offerTitle.value,
                        icon: const Icon(
                          Icons.arrow_downward,
                          color: kPrimaryColor,
                        ),
                        elevation: 16,
                        style: const TextStyle(color: kPrimaryColor),
                        underline: Container(
                          height: 2,
                          color: kPrimaryColor,
                        ),
                        onChanged: (String? title) {
                          offerTitle.value = title;
                          offerID = offerProvider.offers
                              .where((offer) => offer.title == title)
                              .first
                              .id!;
                        },
                        items: offerProvider.offers
                            .map<DropdownMenuItem<String>>((offer) =>
                                DropdownMenuItem(
                                    value: offer.title,
                                    child: Text('${offer.title}')))
                            .toList(),
                      )
                    ],
                  )
                ],
              );
            },
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextButton(
                    onPressed: () {
                      newWorksite();
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add,
                          color: kPrimaryColor,
                        ),
                        Text(
                          AppLocalizations.of(context)!.addOffer,
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
        onPressed: newWorksiteDialog,
        label: Row(
          children: [
            const Icon(Icons.add),
            Text(AppLocalizations.of(context)!.worksiteNew),
          ],
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.worksites,
                  style: const TextStyle(fontSize: 32),
                ),
                IconButton(
                    onPressed: () =>
                        {ref.read(worksitesProvider).getWorksites()},
                    icon: const Icon(
                      Icons.refresh,
                      color: kPrimaryColor,
                      size: 32,
                    )),
              ],
            ),
          ),
          Consumer(builder: (context, ref, child) {
            final worksiteProvider = ref.watch(worksitesProvider);
            return worksiteProvider.worksites.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: worksiteProvider.worksites.length,
                      itemBuilder: (BuildContext context, int index) {
                        return WorksiteContainer(
                          worksite: worksiteProvider.worksites[index],
                        );
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Center(
                        child:
                            Text(AppLocalizations.of(context)!.noOfferInfo)));
          })
        ],
      ),
    );
  }
}
