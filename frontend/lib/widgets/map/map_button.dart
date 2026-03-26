import 'package:flutter/material.dart';

class MapButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget iconWidget;
  final EdgeInsets edgeInsets;

  const MapButton({
    super.key,
    required this.onPressed,
    required this.iconWidget,
    required this.edgeInsets,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: edgeInsets,
        child: FloatingActionButton(
          mini: true,
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurfaceVariant,
          onPressed: onPressed,
          shape: const CircleBorder(),
          child: iconWidget,
        ),
      ),
    );
  }
}
