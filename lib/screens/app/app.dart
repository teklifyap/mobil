import 'package:flutter/material.dart';
import 'package:teklifyap/screens/offers_screen/offers_screen.dart';
import 'package:teklifyap/screens/profile_screen/profile_screen.dart';
import 'package:teklifyap/screens/storage_screen/storage_screen.dart';
import 'package:teklifyap/utils/constants.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  PageController pageController = PageController(initialPage: 1);
  int selectedPage = 1;

  List<Widget> screens = [
    const StorageScreen(),
    const OffersScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(controller: pageController, children: screens),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              iconSize: 32,
              icon: const Icon(Icons.warehouse),
              color: selectedPage == 0 ? kPrimaryColor : Colors.grey,
              onPressed: () {
                pageController.animateToPage(0,
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn);
                setState(() {
                  selectedPage = 0;
                });
              },
            ),
            IconButton(
              iconSize: 32,
              icon: const Icon(
                Icons.local_offer,
              ),
              color: selectedPage == 1 ? kPrimaryColor : Colors.grey,
              onPressed: () {
                pageController.animateToPage(1,
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn);
                setState(() {
                  selectedPage = 1;
                });
              },
            ),
            IconButton(
              iconSize: 32,
              icon: const Icon(
                Icons.person,
              ),
              color: selectedPage == 2 ? kPrimaryColor : Colors.grey,
              onPressed: () {
                pageController.animateToPage(2,
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn);
                setState(() {
                  selectedPage = 2;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
