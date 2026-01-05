import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

String _channelToHex(num channel) => ((channel * 255.0).round() & 0xff)
    .toRadixString(16)
    .padLeft(2, '0')
    .toUpperCase();

String colorToHex(Color color) {
  return '#'
      '${_channelToHex(color.a)}'
      '${_channelToHex(color.r)}'
      '${_channelToHex(color.g)}'
      '${_channelToHex(color.b)}';
}

Color colorFromHex(String hex) {
  hex = hex.replaceAll("#", "");
  if (hex.length == 6) hex = "FF$hex";
  return Color(int.parse(hex, radix: 16));
}

final Map<String, IconData> iconMap = {
  "location_pin": Icons.location_pin,
  "camera_alt": Icons.camera_alt,
  "fort": Icons.fort,
  "house": Icons.house,
  "forest": Icons.forest,
  "camping": Symbols.camping,
  "local_dining": Icons.local_dining,
  "exercise": Symbols.exercise,
  "home_and_garden": Symbols.home_and_garden,
  "pergola": Symbols.pergola,
  "local_florist": Symbols.local_florist,
  "table_picnic": MdiIcons.tablePicnic,
  "tower_fire": MdiIcons.towerFire,
  "add": Icons.add,
};

IconData iconFromString(String iconName) {
  return iconMap[iconName] ?? Icons.location_pin;
}

String stringFromIcon(IconData icon) {
  return iconMap.entries
      .firstWhere(
        (entry) => entry.value == icon,
        orElse: () => const MapEntry("location_pin", Icons.location_pin),
      )
      .key;
}

final List<Color> availableColors = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.lightGreen,
  Colors.blue,
  Colors.purple,
  Colors.pink,
];
