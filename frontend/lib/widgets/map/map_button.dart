import 'package:flutter/material.dart';

class MapButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final EdgeInsets edgeInsets;

  const MapButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.edgeInsets,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: edgeInsets,
        child: FloatingActionButton(
          mini: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          onPressed: onPressed,
          shape: const CircleBorder(),
          child: Icon(icon),
        ),
      ),
    );
  }
}
