import 'package:flutter/material.dart';
import 'package:serpa_maps/widgets/map/map_button.dart';

class CompassButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CompassButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MapButton(
      onPressed: onPressed,
      icon: Icons.explore,
      edgeInsets: const EdgeInsets.only(top: 180, right: 5),
    );
  }
}
