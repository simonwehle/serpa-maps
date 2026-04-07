import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/pages/group_screen.dart';
import 'package:serpa_maps/providers/data/user_prodiver.dart';
import 'package:serpa_maps/utils/dialogs.dart';
import 'package:serpa_maps/widgets/sheets/appearance_sheet.dart';
import 'package:serpa_maps/widgets/sheets/category_sheet.dart';
import 'package:serpa_maps/widgets/sheets/serpa_static_sheet.dart';
import 'package:serpa_maps/widgets/sheets/url_sheet.dart';

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i10n = AppLocalizations.of(context)!;
    final userAsync = ref.watch(userProvider);

    return SerpaStaticSheet(
      title: userAsync.when(
        data: (user) => user?.name ?? i10n.anonymousUser,
        loading: () => i10n.loading,
        error: (error, stackTrace) => i10n.error,
      ),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              showSerpaStaticSheet(context: context, child: AppearanceSheet());
            },
            child: Text(i10n.appearance),
          ),
          ElevatedButton(
            onPressed: () {
              showSerpaStaticSheet(context: context, child: CategorySheet());
            },
            child: Text(i10n.categories),
          ),
          ElevatedButton(
            onPressed: () {
              showSerpaStaticSheet(context: context, child: UrlSheet());
            },
            child: Text(i10n.settings),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GroupScreen()),
              );
            },
            child: Text(i10n.groups),
          ),
          ElevatedButton(
            onPressed: () async {
              final confirmed = await showLogoutConfirmationDialog(context);
              if (confirmed) {
                ref.read(userProvider.notifier).logout().catchError((_) {});
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(i10n.logout),
          ),
        ],
      ),
    );
  }
}
