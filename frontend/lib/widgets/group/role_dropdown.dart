import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/models/member.dart';
import 'package:serpa_maps/models/role.dart';
import 'package:serpa_maps/providers/data/group_member_provider.dart';
import 'package:serpa_maps/widgets/banner/top_banner.dart';

class RoleDropdown extends ConsumerWidget {
  const RoleDropdown({super.key, required this.member, required this.groupId});

  final Member member;
  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    if (member.role == Role.pending) {
      return _staticIcon();
    }

    return PopupMenuButton<Role>(
      padding: EdgeInsets.zero,
      iconSize: 24,
      style: const ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(member.role.icon), const Icon(Icons.arrow_drop_down)],
      ),
      onSelected: (newRole) async {
        await ref
            .read(groupMemberProvider(groupId).notifier)
            .updateGroupMemberRole(memberId: member.userId, role: newRole);
        showTopBanner(
          l10n.updateGroupMemberRole(member.username, newRole.label),
        );
      },
      itemBuilder: (_) => [Role.admin, Role.editor, Role.member]
          .map(
            (role) => PopupMenuItem(
              value: role,
              child: Row(
                children: [
                  Icon(role.icon),
                  const SizedBox(width: 8),
                  Text(role.label),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _staticIcon() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [Icon(member.role.icon), const SizedBox(width: 24)],
  );
}
