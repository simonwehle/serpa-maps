import 'package:flutter/material.dart';
import 'package:serpa_maps/widgets/markers/place_marker.dart';

class ClickableMarker extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int placeId;
  const ClickableMarker({
    super.key,
    required this.icon,
    required this.color,
    required this.placeId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("Place $placeId clicked");
      },
      child: PlaceMarker(icon: icon, color: color),
    );
  }
}
