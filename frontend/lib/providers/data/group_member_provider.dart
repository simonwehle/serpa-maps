import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/models/member.dart';
import 'package:serpa_maps/models/role.dart';
import 'package:serpa_maps/providers/api/api_provider.dart';

final groupMemberProvider =
    AsyncNotifierProvider.family<GroupMemberNotifier, List<Member>, String>(
      GroupMemberNotifier.new,
    );

class GroupMemberNotifier extends AsyncNotifier<List<Member>> {
  GroupMemberNotifier(this.groupId);

  final String groupId;

  @override
  Future<List<Member>> build() async {
    ref.keepAlive();
    final api = ref.read(apiServiceProvider);
    return await api.getGroupMembers(groupId: groupId);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  // Future<void> addMember(Member member) async {
  //   final api = ref.read(apiServiceProvider);
  //   await api.addGroupMember(groupId: groupId, member: member);
  //   ref.invalidateSelf();
  //   await future;
  // }

  Future<void> removeMember(String userId) async {
    final api = ref.read(apiServiceProvider);
    await api.removeGroupMember(groupId: groupId, memberId: userId);
    state = state.whenData(
      (members) => members.where((m) => m.userId != userId).toList(),
    );
    await future;
  }

  Future<void> updateGroupMemberRole({
    required String memberId,
    required Role role,
  }) async {
    final api = ref.read(apiServiceProvider);
    await api.updateGroupMemberRole(
      groupId: groupId,
      memberId: memberId,
      role: role,
    );
    state = state.whenData(
      (members) => members
          .map(
            (m) => m.userId == memberId
                ? Member(
                    userId: m.userId,
                    username: m.username,
                    role: role,
                    joinedAt: m.joinedAt,
                  )
                : m,
          )
          .toList(),
    );
  }
}
