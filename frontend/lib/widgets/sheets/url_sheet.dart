import 'package:flutter/material.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/widgets/place/place_form_actions.dart';
import 'package:serpa_maps/widgets/sheets/serpa_static_sheet.dart';
import 'package:serpa_maps/widgets/url/url_text_fields.dart';

class UrlSheet extends StatelessWidget {
  const UrlSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;
    Future<void> Function()? persistUrlsCallback;
    return SerpaStaticSheet(
      title: i10n.settings,
      child: Column(
        children: [
          UrlTextFields(
            persistChanges: (callback) {
              persistUrlsCallback = callback;
            },
          ),
          PlaceFormActions(
            onCancel: () => Navigator.pop(context),
            onSave: () async {
              if (persistUrlsCallback != null) {
                await persistUrlsCallback!();
              }
            },
          ),
        ],
      ),
    );
  }
}
