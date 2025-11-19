import 'package:flutter/material.dart';
import 'package:serpa_maps/widgets/sheets/sheet_button.dart';

class SheetHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const SheetHeader({super.key, required this.title, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            if (onPressed != null)
              SheetButton(icon: Icons.edit, onPressed: () => onPressed!()),
            const SizedBox(width: 12),
            SheetButton(
              icon: Icons.close,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ],
    );
  }
}
