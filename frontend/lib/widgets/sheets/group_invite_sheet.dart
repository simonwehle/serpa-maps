import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/models/group.dart';
import 'package:serpa_maps/providers/data/group_member_provider.dart';
import 'package:serpa_maps/widgets/form/form_text_field.dart';
import 'package:serpa_maps/widgets/place/place_form_actions.dart';
import 'package:serpa_maps/widgets/sheets/serpa_static_sheet.dart';

class GroupInviteSheet extends ConsumerStatefulWidget {
  final Group group;
  const GroupInviteSheet({super.key, required this.group});

  @override
  ConsumerState<GroupInviteSheet> createState() => _GroupInviteSheetState();
}

class _GroupInviteSheetState extends ConsumerState<GroupInviteSheet> {
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SerpaStaticSheet(
      title: l10n.inviteGroupMember,
      child: Column(
        children: [
          FormTextField(label: l10n.username, controller: usernameController),
          const SizedBox(height: 16),
          PlaceFormActions(
            onCancel: () => Navigator.pop(context),
            onSave: () {
              ref
                  .read(groupMemberProvider(widget.group.groupId).notifier)
                  .inviteToGroup(usernameController.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.inviteGroupMemberConfirmation(
                      usernameController.text,
                      widget.group.name,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
