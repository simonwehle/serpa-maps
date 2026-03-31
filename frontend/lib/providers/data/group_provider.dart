import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/models/group.dart';
import 'package:serpa_maps/providers/api/api_provider.dart';

final groupProvider = AsyncNotifierProvider<GroupNotifier, List<Group>>(
  GroupNotifier.new,
);

class GroupNotifier extends AsyncNotifier<List<Group>> {
  @override
  Future<List<Group>> build() async {
    final api = ref.read(apiServiceProvider);
    return await api.fetchGroups();
  }

  Future<Group?> addGroup({required String name, String? description}) async {
    final api = ref.read(apiServiceProvider);
    final addedGroup = await api.addGroup(name: name, description: description);
    state = state.whenData((groups) => [...groups, addedGroup]);
    return addedGroup;
  }

  Future<void> deleteGroup({required String id}) async {
    final api = ref.read(apiServiceProvider);
    await api.deleteGroup(id: id);
    state = state.whenData(
      (groups) => groups.where((g) => g.groupId != id).toList(),
    );
  }
}
