import 'package:flutter/material.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';

Future<bool> showDeleteConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final i10n = AppLocalizations.of(context)!;
  final result = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        OutlinedButton(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll<Color>(
              Theme.of(context).colorScheme.onSurface,
            ),
          ),
          onPressed: () => Navigator.pop(context, false),
          child: Text(i10n.cancel),
        ),
        OutlinedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color>(
              Theme.of(context).colorScheme.error,
            ),
            foregroundColor: WidgetStatePropertyAll<Color>(
              Theme.of(context).colorScheme.onError,
            ),
            side: WidgetStatePropertyAll<BorderSide>(
              BorderSide(color: Theme.of(context).colorScheme.error),
            ),
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(i10n.yes),
        ),
      ],
    ),
  );
  return result ?? false;
}
