import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/services/api/user_actions.dart';
import 'package:teklifyap/services/models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void getUser() async {
    _user = await UserActions.getUser();
    notifyListeners();
  }
}

final userProvider = ChangeNotifierProvider((ref) => UserProvider());
