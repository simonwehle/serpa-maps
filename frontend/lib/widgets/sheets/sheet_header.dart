import 'package:flutter/material.dart';
import 'package:serpa_maps/widgets/fields/serpa_title.dart';
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
        SerpaTitle(title: title),
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
