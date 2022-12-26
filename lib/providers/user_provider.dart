import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/services/api/user_actions.dart';
import 'package:teklifyap/services/models/user.dart';

class UserProvider extends StateNotifier<User?> {
  UserProvider() : super(null);

  void getUser() async {
    state = await UserActions().getUser();
  }
}

final userProvider =
    StateNotifierProvider<UserProvider, User?>((ref) => UserProvider());
