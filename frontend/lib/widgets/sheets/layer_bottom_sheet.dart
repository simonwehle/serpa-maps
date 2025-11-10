import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/pmtiles_provider.dart';
import 'package:serpa_maps/widgets/sheets/serpa_bottom_sheet.dart';

class LayerBottomSheet extends ConsumerWidget {
  final String activeLayer;
  final ValueChanged<String> onLayerSelected;
  final bool showPlaceMarkers;
  final void Function(bool) togglePlaceMarkers;
  final bool showPMTiles;
  final void Function(bool) togglePMTilesLayer;

  const LayerBottomSheet({
    super.key,
    required this.activeLayer,
    required this.onLayerSelected,
    required this.showPlaceMarkers,
    required this.togglePlaceMarkers,
    required this.showPMTiles,
    required this.togglePMTilesLayer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SerpaBottomSheet(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeLayer == 'Vector'
                        ? Colors.lightBlue
                        : null,
                  ),
                  onPressed: () {
                    onLayerSelected("Vector");
                    Navigator.of(context).pop();
                  },
                  child: const Text("Vector"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeLayer == 'OSM'
                        ? Colors.lightBlue
                        : null,
                  ),
                  onPressed: () {
                    onLayerSelected("OSM");
                    Navigator.of(context).pop();
                  },
                  child: const Text("OSM"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeLayer == 'Satellite'
                        ? Colors.blue
                        : null,
                  ),
                  onPressed: () {
                    onLayerSelected("Satellite");
                    Navigator.of(context).pop();
                  },
                  child: const Text("Satellite"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Show Markers'),
                Switch(value: showPlaceMarkers, onChanged: togglePlaceMarkers),
              ],
            ),
            if (ref.read(pmtilesProvider) != '')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Show PMTiles Layer'),
                  Switch(value: showPMTiles, onChanged: togglePMTilesLayer),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
