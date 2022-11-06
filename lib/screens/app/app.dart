import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:teklifyap/screens/offers_screen/offers_screen.dart';
import 'package:teklifyap/screens/profile_screen/profile_screen.dart';
import 'package:teklifyap/screens/storage_screen/storage_screen.dart';
import 'package:teklifyap/utils/constants.dart';

class App extends HookWidget {
  App({Key? key}) : super(key: key);

  final List<Widget> screens = [
    const StorageScreen(),
    const OffersScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    PageController pageController =
        usePageController(initialPage: 1, keys: screens);
    final selectedPage = useState(pageController.hasClients
        ? pageController.page!.toInt()
        : pageController.initialPage.toInt());

    return Scaffold(
      body: PageView(controller: pageController, children: screens),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              iconSize: 32,
              icon: const Icon(Icons.warehouse),
              color: selectedPage.value == 0 ? kPrimaryColor : Colors.grey,
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
              color: selectedPage.value == 1 ? kPrimaryColor : Colors.grey,
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
                Icons.person,
              ),
              color: selectedPage.value == 2 ? kPrimaryColor : Colors.grey,
              onPressed: () {
                selectedPage.value = 2;
                pageController.animateToPage(2,
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
