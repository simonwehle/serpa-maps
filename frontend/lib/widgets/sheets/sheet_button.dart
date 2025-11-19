import 'package:flutter/material.dart';

class SheetButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const SheetButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final size = 15.0;
    return CircleAvatar(
      backgroundColor: Colors.grey[300],
      radius: size,
      child: IconButton(icon: Icon(icon), onPressed: onPressed, iconSize: size),
    );
  }
}
