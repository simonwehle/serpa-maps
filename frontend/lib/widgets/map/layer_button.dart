import 'package:flutter/material.dart';
import 'package:serpa_maps/widgets/map/map_button.dart';

class LayerButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LayerButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MapButton(
      onPressed: onPressed,
      icon: Icons.layers,
      edgeInsets: const EdgeInsets.only(top: 125, right: 5),
    );
  }
}
