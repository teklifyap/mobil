import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/provider/employee_provider.dart';
import 'package:teklifyap/provider/item_provider.dart';
import 'package:teklifyap/provider/offer_provider.dart';
import 'package:teklifyap/provider/user_provider.dart';
import 'package:teklifyap/provider/worksite_provider.dart';
import 'package:teklifyap/screens/employee_screen/employee_screen.dart';
import 'package:teklifyap/screens/offers_screen/offers_screen.dart';
import 'package:teklifyap/screens/profile_screen/profile_screen.dart';
import 'package:teklifyap/screens/storage_screen/storage_screen.dart';
import 'package:teklifyap/constants.dart';
import 'package:teklifyap/screens/worksites_screen/worksites_screen.dart';

class App extends HookConsumerWidget {
  App({Key? key}) : super(key: key);

  final List<Widget> screens = [
    const StorageScreen(),
    const OffersScreen(),
    const EmployeeScreen(),
    const WorksitesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //load data
    ref.read(itemsProvider).getItems();
    ref.read(userProvider).getUser();
    ref.read(offersProvider).getOffers();
    ref.read(employeesProvider).getEmployees();
    ref.read(worksitesProvider).getWorksites();
    PageController pageController =
        usePageController(initialPage: 2, keys: screens);
    final selectedPage = useState(pageController.hasClients
        ? pageController.page!.toInt()
        : pageController.initialPage.toInt());

    return Scaffold(
      body: PageView(
        controller: pageController,
        children: screens,
        onPageChanged: (changedPage) {
          selectedPage.value = changedPage;
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              iconSize: 32,
              icon: const Icon(Icons.warehouse),
              color: selectedPage.value == 0 ? kPrimaryColor : kSecondaryColor,
              onPressed: () {
                selectedPage.value = 0;
                pageController.animateToPage(0,
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn);
              },
            ),
            IconButton(
              iconSize: 32,
              icon: const Icon(
                Icons.local_offer,
              ),
              color: selectedPage.value == 1 ? kPrimaryColor : kSecondaryColor,
              onPressed: () {
                selectedPage.value = 1;
                pageController.animateToPage(1,
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn);
              },
            ),
            IconButton(
              iconSize: 32,
              icon: const Icon(
                Icons.people,
              ),
              color: selectedPage.value == 2 ? kPrimaryColor : kSecondaryColor,
              onPressed: () {
                selectedPage.value = 2;
                pageController.animateToPage(2,
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn);
              },
            ),
            IconButton(
              iconSize: 32,
              icon: const Icon(
                Icons.apartment,
              ),
              color: selectedPage.value == 3 ? kPrimaryColor : kSecondaryColor,
              onPressed: () {
                selectedPage.value = 3;
                pageController.animateToPage(3,
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn);
              },
            ),
            IconButton(
              iconSize: 32,
              icon: const Icon(
                Icons.person_outline,
              ),
              color: selectedPage.value == 4 ? kPrimaryColor : kSecondaryColor,
              onPressed: () {
                selectedPage.value = 4;
                pageController.animateToPage(4,
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn);
              },
            ),
          ],
        ),
      ),
    );
  }
}
