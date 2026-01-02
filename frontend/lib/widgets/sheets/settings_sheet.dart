import 'package:flutter/material.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/models/user.dart';
import 'package:serpa_maps/widgets/sheets/serpa_static_sheet.dart';

class SettingsSheet extends StatelessWidget {
  final User? user;

  const SettingsSheet({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;

    return SerpaStaticSheet(
      title: user?.name ?? i10n.user,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              print('Categories pressed');
            },
            child: Text(i10n.categories),
          ),
        ],
      ),
    );
  }
}
