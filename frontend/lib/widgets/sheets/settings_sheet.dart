import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/models/user.dart';
import 'package:serpa_maps/providers/token/access_token_provider.dart';
import 'package:serpa_maps/utils/dialogs.dart';
import 'package:serpa_maps/widgets/sheets/category_sheet.dart';
import 'package:serpa_maps/widgets/sheets/serpa_static_sheet.dart';
import 'package:serpa_maps/widgets/sheets/url_sheet.dart';

class SettingsSheet extends ConsumerWidget {
  final User? user;

  const SettingsSheet({super.key, this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i10n = AppLocalizations.of(context)!;

    return SerpaStaticSheet(
      title: user?.name ?? i10n.anonymousUser,
      child: Column(
        children: [
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
            onPressed: () async {
              final confirmed = await showLogoutConfirmationDialog(context);
              if (confirmed) {
                ref.read(accessTokenProvider.notifier).clearToken();
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
