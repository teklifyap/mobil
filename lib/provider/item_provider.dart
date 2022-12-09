import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/services/api/item_actions.dart';
import 'package:teklifyap/services/models/item.dart';

class ItemProvider extends ChangeNotifier {
  List<Item> items = [];

  void getItems() async {
    items = await ItemActions.getAllItems();
    items = List.from(items.reversed);
    notifyListeners();
  }
}

final itemsProvider = ChangeNotifierProvider((ref) => ItemProvider());
