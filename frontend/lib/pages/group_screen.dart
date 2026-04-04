import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/pages/group_detail_screen.dart';
import 'package:serpa_maps/providers/data/group_provider.dart';
import 'package:serpa_maps/providers/data/invite_provider.dart';
import 'package:serpa_maps/providers/data/user_prodiver.dart';
import 'package:serpa_maps/utils/dialogs.dart';
import 'package:serpa_maps/widgets/group/group_header.dart';
import 'package:serpa_maps/widgets/sheets/add_group_sheet.dart';
import 'package:serpa_maps/widgets/sheets/serpa_static_sheet.dart';

class GroupScreen extends ConsumerWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final groupsAsync = ref.watch(groupProvider);
    final invitesAsync = ref.watch(inviteProvider);
    final user = ref.watch(userProvider);

    acceptInvite({required String id}) {
      ref.read(inviteProvider.notifier).respondToInvite(id: id, accept: true);
    }

    declineInvite({required String id}) {
      ref.read(inviteProvider.notifier).respondToInvite(id: id, accept: false);
    }

    return Scaffold(
      appBar: AppBar(title: Text("Groups")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            GroupHeader(
              title: "Invites",
              icon: Icons.refresh,
              onPressed: () {
                ref.invalidate(inviteProvider);
              },
            ),
            ...invitesAsync.when(
              data: (invites) => invites.isEmpty
                  ? [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text("No group invites available."),
                        ),
                      ),
                    ]
                  : invites
                        .map(
                          (invite) => ListTile(
                            title: Text(invite.groupName),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  color: colorScheme.tertiary,
                                  onPressed: () =>
                                      acceptInvite(id: invite.groupInviteId),
                                  icon: Icon(Icons.check),
                                ),
                                IconButton(
                                  color: colorScheme.error,
                                  onPressed: () =>
                                      declineInvite(id: invite.groupInviteId),
                                  icon: Icon(Icons.close),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
              loading: () => [Center(child: CircularProgressIndicator())],
              error: (e, _) => [Center(child: Text(e.toString()))],
            ),
            Divider(),
            GroupHeader(
              title: "Groups",
              icon: Icons.add,
              onPressed: () {
                showSerpaStaticSheet(
                  context: context,
                  child: AddGroupBottomSheet(),
                );
              },
            ),
            ...groupsAsync.when(
              data: (groups) => groups.isEmpty
                  ? [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            "No groups available. Create one with the + Button",
                          ),
                        ),
                      ),
                    ]
                  : groups
                        .map(
                          (group) => ListTile(
                            title: Text(group.name),
                            // subtitle: group.description != ""
                            //     ? Text(group.description!)
                            //     : null,
                            onTap: group.role == 'member'
                                ? null
                                : () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            GroupDetailScreen(group: group),
                                      ),
                                    );
                                  },
                            trailing: group.role == 'member'
                                ? IconButton(
                                    icon: Icon(Icons.logout),
                                    onPressed: () async {
                                      final confirmed =
                                          await showConfirmationDialog(
                                            context,
                                            title: "Leave Group",
                                            message:
                                                "Do you want to leave this group?",
                                          );
                                      if (confirmed) {
                                        user.whenData((user) async {
                                          if (user != null) {
                                            await ref
                                                .read(groupProvider.notifier)
                                                .removeGroupMember(
                                                  groupId: group.groupId,
                                                  memberId: user.userId,
                                                );
                                            ref.invalidate(groupProvider);
                                          }
                                        });
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
      ),
    );
  }
}
