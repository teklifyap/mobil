import 'package:flutter/material.dart';

class L10n {
  static final all = [const Locale('en'), const Locale('tr')];

  static String getFlag(String code) {
    switch (code) {
      case 'tr':
        return 'πΉπ·';
      case 'en':
      default:
        return 'πΊπΈ';
    }
  }
}
