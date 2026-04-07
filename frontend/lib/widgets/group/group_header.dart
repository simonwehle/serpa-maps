import 'package:flutter/material.dart';
import 'package:serpa_maps/widgets/fields/serpa_title.dart';

class GroupHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const GroupHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SerpaTitle(title: title),
        IconButton(icon: Icon(icon), onPressed: onPressed),
      ],
    );
  }
}
