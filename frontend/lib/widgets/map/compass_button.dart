import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:serpa_maps/widgets/map/map_button.dart';

class CompassButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double bearing; // in degrees

  const CompassButton({
    super.key,
    required this.onPressed,
    required this.bearing,
  });

  @override
  Widget build(BuildContext context) {
    return MapButton(
      onPressed: onPressed,
      iconWidget: Transform.rotate(
        angle: -bearing * math.pi / 180,
        child: const Icon(Icons.navigation),
      ),
      edgeInsets: const EdgeInsets.only(top: 180, right: 5),
    );
  }
}
