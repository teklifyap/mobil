import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/services/api/item_actions.dart';
import 'package:teklifyap/services/models/item.dart';

class ItemProvider extends ChangeNotifier {
  List<Item> items = [];

  void getItems() async {
    items = await ItemActions.getAllItems();
    items.sort(
      (a, b) => b.id!.compareTo(a.id!),
    );
    notifyListeners();
  }
}

final itemsProvider = ChangeNotifierProvider((ref) => ItemProvider());
