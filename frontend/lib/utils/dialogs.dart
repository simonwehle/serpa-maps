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
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(i10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(i10n.yes),
        ),
      ],
    ),
  );
  return result ?? false;
}
