import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

Widget pmtilesLayer({required String pmtiles, required bool showPMTiles}) {
  if (showPMTiles) {
    return TileLayer(
      urlTemplate: pmtiles,
      userAgentPackageName: 'org.serpamaps',
    );
  } else {
    return const SizedBox.shrink();
  }
}
