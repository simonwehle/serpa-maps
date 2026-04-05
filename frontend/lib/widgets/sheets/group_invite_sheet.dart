import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/providers/api/api_provider.dart';
import 'package:serpa_maps/widgets/form/form_text_field.dart';
import 'package:serpa_maps/widgets/place/place_form_actions.dart';
import 'package:serpa_maps/widgets/sheets/serpa_static_sheet.dart';

class GroupInviteSheet extends ConsumerStatefulWidget {
  final String groupId;
  const GroupInviteSheet({super.key, required this.groupId});

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
    final i10n = AppLocalizations.of(context)!;
    return SerpaStaticSheet(
      title: "Invite Group Member",
      child: Column(
        children: [
          FormTextField(label: i10n.username, controller: usernameController),
          const SizedBox(height: 16),
          PlaceFormActions(
            onCancel: () => Navigator.pop(context),
            onSave: () {
              ref
                  .read(apiServiceProvider)
                  .inviteToGroup(
                    groupId: widget.groupId,
                    username: usernameController.text,
                  );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
