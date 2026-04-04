import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/pages/group_screen.dart';
import 'package:serpa_maps/providers/api/api_provider.dart';
import 'package:serpa_maps/providers/data/user_prodiver.dart';
import 'package:serpa_maps/providers/token/access_token_provider.dart';
import 'package:serpa_maps/providers/token/refresh_token_provider.dart';
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
        loading: () => "Loading...",
        error: (error, stackTrace) => "Error",
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
            child: Text("Groups"),
          ),
          ElevatedButton(
            onPressed: () async {
              final confirmed = await showLogoutConfirmationDialog(context);
              if (confirmed) {
                final refreshToken = ref.read(refreshTokenProvider);
                if (refreshToken != null) {
                  ref
                      .read(apiServiceProvider)
                      .logout(refreshToken: refreshToken)
                      .catchError((_) {});
                }
                ref.read(accessTokenProvider.notifier).clearToken();
                ref.read(refreshTokenProvider.notifier).clearToken();
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
