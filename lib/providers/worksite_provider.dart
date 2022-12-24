import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/services/api/worksite_actions.dart';
import 'package:teklifyap/services/models/worksite.dart';

class WorksiteProvider extends ChangeNotifier {
  List<Worksite> worksites = [];

  void getWorksites() async {
    worksites = await WorksiteActions.getAllWorksites();
    worksites.sort(
      (a, b) => b.id!.compareTo(a.id!),
    );
    notifyListeners();
  }
}

final worksitesProvider = ChangeNotifierProvider((ref) => WorksiteProvider());
