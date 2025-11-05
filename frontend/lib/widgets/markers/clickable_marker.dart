import 'package:flutter/material.dart';
import 'package:serpa_maps/widgets/markers/place_marker.dart';

class ClickableMarker extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int placeId;
  final void Function(int) onTap;
  const ClickableMarker({
    super.key,
    required this.icon,
    required this.color,
    required this.placeId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap,
      child: PlaceMarker(icon: icon, color: color),
    );
  }
}
