import 'package:flutter/material.dart';
import 'package:serpa_maps/utils/dialogs.dart';

class DeleteButton extends StatelessWidget {
  final String title;
  final String question;
  final Future<void> Function() deleteFunction;

  const DeleteButton({
    super.key,
    required this.deleteFunction,
    required this.title,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
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
      onPressed: () async {
        final confirmed = await showConfirmationDialog(
          context,
          title: title,
          message: question,
          backgroundColor: Theme.of(context).colorScheme.error,
          foregroundColor: Theme.of(context).colorScheme.onError,
        );
        if (confirmed) {
          await deleteFunction();
        }
      },
      child: Text(title),
    );
  }
}
