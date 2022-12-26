import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:teklifyap/services/api/worksite_actions.dart';
import 'package:teklifyap/services/models/worksite.dart';

class WorksiteProvider extends StateNotifier<List<Worksite>> {
  WorksiteProvider() : super([]);

  void getWorksites() async {
    state = await WorksiteActions().getAllWorksites();
    state.sort(
      (a, b) => b.id!.compareTo(a.id!),
    );
  }
}

final worksitesProvider =
    StateNotifierProvider<WorksiteProvider, List<Worksite>>(
        (ref) => WorksiteProvider());
