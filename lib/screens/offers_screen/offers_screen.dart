import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:teklifyap/app_data.dart';
import 'package:teklifyap/screens/offers_screen/components/offer_container.dart';
import 'package:teklifyap/screens/storage_screen/components/input_field.dart';
import 'package:teklifyap/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OffersScreen extends HookWidget {
  const OffersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final offers = useState(AppData.offers);
    final offersTrigger = useState(0);
    final offerTitleController = useTextEditingController();
    final offerToWhomController = useTextEditingController();
    int profitRate = 0;
    int appxFinishTime = 0;
    DateTime dateController = DateTime.now();

    void removeOffer(int index) {
      offers.value.removeAt(index);
      offersTrigger.value++;
    }

    void addOffer() {
      offers.value.add(["yeniTeklif", "YeniteklifAfsadf"]);
    }

    Future createItemDialog() async {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.newOffer),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          content: HookBuilder(builder: (context) {
            DateTime currentDate = DateTime.now();
            final selectedDate = useState(currentDate);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomInputField(
                    controller: offerTitleController,
                    labelText: AppLocalizations.of(context)!.offerTitle),
                CustomInputField(
                    controller: offerToWhomController,
                    labelText: AppLocalizations.of(context)!.offerTo),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${AppLocalizations.of(context)!.date}: '),
                      GestureDetector(
                          child: Text(
                              '${selectedDate.value.year}/${selectedDate.value.month}/${selectedDate.value.day}'),
                          onTap: () async {
                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: currentDate,
                              firstDate: DateTime(1990),
                              lastDate: DateTime(2100),
                            );

                            if (newDate == null) {
                              return;
                            }

                            selectedDate.value = newDate;
                          })
                    ],
                  ),
                ),
                CustomInputField(
                    controller: offerToWhomController,
                    labelText: AppLocalizations.of(context)!.profitRate),
                CustomInputField(
                    controller: offerToWhomController,
                    labelText:
                        AppLocalizations.of(context)!.estimatedCompletion),
              ],
            );
          }),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextButton(
                    onPressed: () {
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
        onPressed: () => createItemDialog(),
        label: Row(
          children: [
            const Icon(Icons.add),
            Text(AppLocalizations.of(context)!.newOffer),
          ],
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 15),
            child: Stack(
              children: [
                Text(
                  offersTrigger.value.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    AppLocalizations.of(context)!.offersTitle,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ],
            ),
          ),
          offers.value.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: offers.value.length,
                    itemBuilder: (BuildContext context, int index) {
                      return OfferContainer(
                        offerTitle: offers.value[index][0],
                        offerDate: offers.value[index][1],
                        onListTileTap: () => {},
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.grey,
                          onPressed: () => removeOffer(index),
                        ),
                      );
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: Center(
                      child: Text(AppLocalizations.of(context)!.noOfferInfo)))
        ],
      ),
    );
  }
}
