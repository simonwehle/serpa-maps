import 'package:flutter/material.dart';

Color colorFromHex(String hex) {
  hex = hex.replaceAll("#", "");
  if (hex.length == 6) hex = "FF$hex";
  return Color(int.parse(hex, radix: 16));
}

IconData iconFromString(String iconName) {
  const map = {
    "camera_alt": Icons.camera_alt,
    "fort": Icons.fort,
    "restaurant": Icons.restaurant,
    "location_on": Icons.location_on,
    "house": Icons.house,
  };
  return map[iconName] ?? Icons.location_on;
}
