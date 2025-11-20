import 'package:flutter/material.dart';

class PlaceFormButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const PlaceFormButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0,
      width: 56.0,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: IconButton(icon: Icon(icon), onPressed: onPressed),
    );
  }
}
