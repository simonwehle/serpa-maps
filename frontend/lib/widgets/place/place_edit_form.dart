import 'package:flutter/material.dart';

class PlaceEditForm extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final bool isNew;

  const PlaceEditForm({
    super.key,
    required this.onCancel,
    required this.onSave,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: onSave,
              child: Text(isNew ? 'Add' : 'Save'),
            ),
          ),
        ],
      ),
    );
  }
}
