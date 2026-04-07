import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/models/group.dart';
import 'package:serpa_maps/providers/data/group_provider.dart';
import 'package:serpa_maps/utils/dialogs.dart';
import 'package:serpa_maps/widgets/sheets/group_invite_sheet.dart';
import 'package:serpa_maps/widgets/sheets/serpa_static_sheet.dart';

class GroupDetailScreen extends ConsumerWidget {
  final Group group;
  const GroupDetailScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i10n = Localizations.of(context, AppLocalizations)!;
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
        ],
      ),
    );
  }
}
