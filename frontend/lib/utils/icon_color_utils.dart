import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

Color colorFromHex(String hex) {
  hex = hex.replaceAll("#", "");
  if (hex.length == 6) hex = "FF$hex";
  return Color(int.parse(hex, radix: 16));
}

IconData iconFromString(String iconName) {
  final map = <String, IconData>{
    "camera_alt": Icons.camera_alt,
    "fort": Icons.fort,
    "location_on": Icons.location_on,
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
  };
  return map[iconName] ?? Icons.location_on;
}
