import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/l10n/l10n.dart';

class LocaleProvider extends StateNotifier<Locale?> {
  LocaleProvider() : super(null);

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    state = locale;
  }

  void clearLocale() {
    state = null;
  }
}

final localeProvider =
    StateNotifierProvider<LocaleProvider, Locale?>((ref) => LocaleProvider());
