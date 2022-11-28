import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/services/api/item_actions.dart';
import 'package:teklifyap/services/models/item.dart';

class ItemProvider extends ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items => _items;

  void getItems() async {
    _items = await ItemActions.getAllItems();
    notifyListeners();
  }
}

final itemsProvider = ChangeNotifierProvider((ref) => ItemProvider());
