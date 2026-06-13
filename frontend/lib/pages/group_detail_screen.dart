import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/models/group.dart';
import 'package:serpa_maps/providers/data/group_member_provider.dart';
import 'package:serpa_maps/providers/data/group_provider.dart';
import 'package:serpa_maps/providers/data/user_prodiver.dart';
import 'package:serpa_maps/utils/dialogs.dart';
import 'package:serpa_maps/widgets/sheets/group_invite_sheet.dart';
import 'package:serpa_maps/widgets/sheets/serpa_static_sheet.dart';

class GroupDetailScreen extends ConsumerWidget {
  final Group group;
  const GroupDetailScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i10n = Localizations.of(context, AppLocalizations)!;
    final groupMembersAsync = ref.watch(groupMemberProvider(group.groupId));
    final currentUser = ref.watch(userProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final confirmed = await showDeleteConfirmationDialog(
                context,
                title: i10n.deleteGroup,
                message: i10n.deleteGroupQuestion,
              );
              if (confirmed) {
                await ref
                    .read(groupProvider.notifier)
                    .deleteGroup(id: group.groupId);
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Center(
            child: FilledButton(
              onPressed: () {
                showSerpaStaticSheet(
                  context: context,
                  child: GroupInviteSheet(groupId: group.groupId),
                );
              },
              child: Text(i10n.inviteGroupMember),
            ),
          ),
          const SizedBox(height: 16),
          ...groupMembersAsync.when(
            data: (members) => members.isEmpty
                ? [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: Text(i10n.noGroupMembers)),
                    ),
                  ]
                : members
                      .map(
                        (member) => ListTile(
                          leading: Icon(switch (member.role) {
                            'member' => Icons.visibility,
                            'editor' => Icons.edit,
                            'admin' => Icons.security,
                            _ => Icons.person,
                          }),
                          title: Text(member.username),
                          // subtitle: Text(member.role),
                          trailing: currentUser?.userId != member.userId
                              ? IconButton(
                                  icon: const Icon(Icons.person_remove),
                                  onPressed: () async {
                                    final confirmed =
                                        await showConfirmationDialog(
                                          context,
                                          title: i10n.removeGroupMember,
                                          message:
                                              i10n.removeGroupMemberQuestion,
                                        );

                                    if (confirmed) {
                                      await ref
                                          .read(
                                            groupMemberProvider(
                                              group.groupId,
                                            ).notifier,
                                          )
                                          .removeMember(member.userId);
                                    }
                                  },
                                )
                              : null,
                        ),
                      )
                      .toList(),
            loading: () => [Center(child: CircularProgressIndicator())],
            error: (e, _) => [Center(child: Text(e.toString()))],
          ),
        ],
      ),
    );
  }
}
