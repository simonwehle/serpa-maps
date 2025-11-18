import 'package:flutter/material.dart';

class LayerButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LayerButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 100, 10, 0),
        child: FloatingActionButton(
          mini: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          onPressed: onPressed,
          shape: const CircleBorder(),
          child: const Icon(Icons.layers),
        ),
      ),
    );
  }
}
