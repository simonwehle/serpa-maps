import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/providers/category_provider.dart';
import 'package:serpa_maps/providers/place_provider.dart';
import 'package:serpa_maps/widgets/place/place_form_actions.dart';
import 'package:serpa_maps/widgets/sheets/serpa_static_sheet.dart';
import 'package:serpa_maps/widgets/fields/url_text_fields.dart';

class UrlSheet extends ConsumerWidget {
  const UrlSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i10n = AppLocalizations.of(context)!;
    Future<void> Function()? persistUrlsCallback;
    return SerpaStaticSheet(
      title: i10n.settings,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: UrlTextFields(
              persistChanges: (callback) {
                persistUrlsCallback = callback;
              },
            ),
          ),
          PlaceFormActions(
            onCancel: () => Navigator.pop(context),
            onSave: () async {
              if (persistUrlsCallback != null) {
                await persistUrlsCallback!();

                ref.invalidate(categoryProvider);
                ref.invalidate(placeProvider);

                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
