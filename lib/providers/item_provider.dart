import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/services/api/item_actions.dart';
import 'package:teklifyap/services/models/item.dart';

class ItemProvider extends StateNotifier<List<Item>> {
  ItemProvider() : super([]);
  void getItems() async {
    state = await ItemActions().getAllItems();
    state.sort(
      (a, b) => b.id!.compareTo(a.id!),
    );
  }
}

final itemsProvider =
    StateNotifierProvider<ItemProvider, List<Item>>((ref) => ItemProvider());
