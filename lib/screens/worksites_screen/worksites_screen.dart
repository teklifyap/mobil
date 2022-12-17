import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teklifyap/constants.dart';
import 'package:teklifyap/provider/offer_provider.dart';
import 'package:teklifyap/provider/user_provider.dart';
import 'package:teklifyap/provider/worksite_provider.dart';
import 'package:teklifyap/screens/storage_screen/components/input_field.dart';
import 'package:teklifyap/screens/worksites_screen/components/worksite_container.dart';
import 'package:teklifyap/services/api/worksite_actions.dart';
import 'package:teklifyap/services/models/offer.dart';
import 'package:teklifyap/services/models/worksite.dart';

// ignore: unused_import
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_maps_flutter/google_maps_flutter.dart'
    if (kIsWeb) 'package:google_maps_flutter_web/google_maps_flutter_web.dart'
    as platform;

class WorksitesScreen extends HookConsumerWidget {
  const WorksitesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worksiteNameController = useTextEditingController();
    final worksiteAddressController = useTextEditingController();
    double worksiteLocationX = 0;
    double worksiteLocationY = 0;
    int? offerID = 0;

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
      final formKey = GlobalKey<FormState>();
      Completer<platform.GoogleMapController> mapController = Completer();
      worksiteAddressController.clear();
      worksiteNameController.clear();
      ref.read(offersProvider).getOffers();
      List<Offer> offers = [...ref.read(offersProvider).offers];
      offers.removeWhere((element) => element.status == false);
      // ignore: unused_local_variable
      LocationPermission permission = await Geolocator.requestPermission();
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      // ignore:, use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.worksiteNew),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          content: SingleChildScrollView(
              child: offers.isNotEmpty
                  ? Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomInputField(
                            controller: worksiteNameController,
                            labelText: AppLocalizations.of(context)!.name,
                          ),
                          CustomInputField(
                            controller: worksiteAddressController,
                            labelText:
                                AppLocalizations.of(context)!.worksiteAddress,
                          ),
                          HookBuilder(
                            builder: (context) {
                              offerID = offers
                                  .where((element) => element.status == true)
                                  .toList()
                                  .first
                                  .id;
                              final offerTitle = useState(offers.first.title);
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(AppLocalizations.of(context)!
                                      .worksiteSelectOffer),
                                  DropdownButton<String>(
                                    value: offerTitle.value,
                                    icon: const Icon(
                                      Icons.arrow_downward,
                                      color: kPrimaryColor,
                                    ),
                                    elevation: 16,
                                    style:
                                        const TextStyle(color: kPrimaryColor),
                                    underline: Container(
                                      height: 2,
                                      color: kPrimaryColor,
                                    ),
                                    onChanged: (String? title) {
                                      offerTitle.value = title;
                                      offerID = offers
                                          .where(
                                              (offer) => offer.title == title)
                                          .first
                                          .id!;
                                    },
                                    items: offers
                                        .map<DropdownMenuItem<String>>(
                                            (offer) => DropdownMenuItem(
                                                value: offer.title,
                                                child: Text('${offer.title}')))
                                        .toList(),
                                  )
                                ],
                              );
                            },
                          ),
                          HookBuilder(builder: (context) {
                            final height = MediaQuery.of(context).size.height;
                            final platform.CameraPosition startingPoint =
                                platform.CameraPosition(
                              target: platform.LatLng(currentPosition.latitude,
                                  currentPosition.longitude),
                              zoom: 15,
                            );

                            worksiteLocationX = currentPosition.latitude;
                            worksiteLocationY = currentPosition.longitude;

                            void onCameraMove(
                                platform.CameraPosition position) {
                              worksiteLocationX = position.target.latitude;
                              worksiteLocationY = position.target.longitude;
                            }

                            final isMapSelected = useState(false);
                            if (isMapSelected.value) {
                              return SizedBox(
                                height: height / 2.5,
                                child: Stack(
                                  children: [
                                    platform.GoogleMap(
                                      onCameraMove: onCameraMove,
                                      mapType: platform.MapType.terrain,
                                      initialCameraPosition: startingPoint,
                                      onMapCreated:
                                          (platform.GoogleMapController
                                              controller) {
                                        mapController.complete(controller);
                                      },
                                    ),
                                    const Center(
                                      child: Icon(
                                        Icons.pin_drop,
                                        color: kPrimaryColor,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            } else {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      isMapSelected.value = true;
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.pin_drop,
                                          color: kPrimaryColor,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .worksitePickLocation,
                                          style: const TextStyle(
                                              color: kPrimaryColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                          }),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child:
                          Text(AppLocalizations.of(context)!.offerThereIsNone),
                    )),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextButton(
                    onPressed: offers.isNotEmpty
                        ? () {
                            if (formKey.currentState!.validate()) {
                              newWorksite();
                              Navigator.pop(context);
                            }
                          }
                        : null,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add,
                          color: kPrimaryColor,
                        ),
                        Text(
                          AppLocalizations.of(context)!.worksiteNew,
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
                        child: Text(AppLocalizations.of(context)!.worksiteNo)));
          })
        ],
      ),
    );
  }
}
