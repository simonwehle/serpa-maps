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
}
