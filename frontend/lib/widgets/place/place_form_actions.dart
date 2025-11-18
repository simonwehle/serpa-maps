import 'package:flutter/material.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';

class PlaceFormActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final bool isNew;

  const PlaceFormActions({
    super.key,
    required this.onCancel,
    required this.onSave,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: FilledButton(
              onPressed: onSave,
              child: Text(
                isNew
                    ? AppLocalizations.of(context)!.add
                    : AppLocalizations.of(context)!.save,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
