import 'package:flutter/material.dart';

class PlaceMarker extends StatelessWidget {
  final IconData icon;
  final Color color;
  const PlaceMarker({super.key, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Colors.white, width: 1.0),
      ),
      child: Icon(icon, size: 17.5, color: Colors.white),
    );
  }
}
