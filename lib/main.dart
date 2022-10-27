import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:teklifyap/l10n/l10n.dart';
import 'package:teklifyap/provider/local_provider.dart';
import 'package:teklifyap/screens/splash_screen.dart';
import 'package:teklifyap/utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        builder: (context, child) {
          final provider = Provider.of<LocaleProvider>(context);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: kBackgroundColor,
              textTheme:
                  Theme.of(context).textTheme.apply(bodyColor: kPrimaryColor),
            ),
            supportedLocales: L10n.all,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            locale: provider.locale,
            home: const SplashScreen(
              primaryColor: kPrimaryColor,
            ),
          );
        });
  }
}
