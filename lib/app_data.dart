import 'package:teklifyap/services/models/item.dart';
import 'package:teklifyap/services/models/user.dart';

class AppData {
  static String primaryTitle = "teklifyap";
  static String mainLogoFileName = "main_logo.png";
  static String authToken = "";
  static User? currentUser;
  static List<List<String>> offers = [];
  static List<Item> storageItems = [];
  static int storageItemsTrigger = 0;

  static void triggerStorageItems() {
    storageItemsTrigger++;
  }
}
