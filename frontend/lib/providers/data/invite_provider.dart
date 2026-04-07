import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/models/invite.dart';
import 'package:serpa_maps/providers/api/api_provider.dart';
import 'package:serpa_maps/providers/data/category_provider.dart';
import 'package:serpa_maps/providers/data/group_provider.dart';
import 'package:serpa_maps/providers/data/place_provider.dart';

final inviteProvider = AsyncNotifierProvider<InviteNotifier, List<Invite>>(
  InviteNotifier.new,
);

class InviteNotifier extends AsyncNotifier<List<Invite>> {
  @override
  Future<List<Invite>> build() async {
    final api = ref.read(apiServiceProvider);
    return await api.fetchInvites();
  }

  Future<void> respondToInvite({
    required String id,
    required bool accept,
  }) async {
    final api = ref.read(apiServiceProvider);
    await api.respondToInvite(id: id, accept: accept);
    state = state.whenData(
      (invites) => invites.where((i) => i.groupInviteId != id).toList(),
    );
    if (accept) {
      ref.invalidate(groupProvider);
      ref.invalidate(categoryProvider);
      ref.invalidate(placeProvider);
    }
  }
}
