import 'package:flutter/material.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';

Future<bool> showDeleteConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
}) async {
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
  final l10n = AppLocalizations.of(context)!;
  return showConfirmationDialog(
    context,
    title: l10n.logout,
    message: l10n.logoutQuestion,
  );
}

Future<bool> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  Color? backgroundColor,
  Color? foregroundColor,
}) async {
  final l10n = AppLocalizations.of(context)!;
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
          child: Text(l10n.cancel),
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
          child: Text(l10n.yes),
        ),
      ],
    ),
  );
  return result ?? false;
}
