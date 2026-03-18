import 'package:flutter/material.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';

Future<bool> showDeleteConfirmationDialog(
  BuildContext context,
  String title,
  String message,
) async {
  final colorScheme = Theme.of(context).colorScheme;
  return showConfirmationDialog(
    context,
    title: title,
    message: message,
    backgroundColor: colorScheme.error,
    foregroundColor: colorScheme.onError,
  );
}

Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
  final i10n = AppLocalizations.of(context)!;
  return showConfirmationDialog(
    context,
    title: i10n.logout,
    message: i10n.logoutQuestion,
  );
}

Future<bool> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  Color? backgroundColor,
  Color? foregroundColor,
}) async {
  final i10n = AppLocalizations.of(context)!;
  final colorScheme = Theme.of(context).colorScheme;
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
              backgroundColor ?? colorScheme.primary,
            ),
            foregroundColor: WidgetStatePropertyAll<Color>(
              foregroundColor ?? colorScheme.onPrimary,
            ),
            side: WidgetStatePropertyAll<BorderSide>(
              BorderSide(color: backgroundColor ?? colorScheme.primary),
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
