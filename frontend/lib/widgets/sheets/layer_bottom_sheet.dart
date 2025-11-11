import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/markers_visible_provider.dart';
import 'package:serpa_maps/providers/overlay_active_prvoider.dart';
import 'package:serpa_maps/providers/overlay_url_provider.dart';
import 'package:serpa_maps/widgets/sheets/serpa_bottom_sheet.dart';

class LayerBottomSheet extends ConsumerWidget {
  final String activeLayer;
  final ValueChanged<String> onLayerSelected;

  const LayerBottomSheet({
    super.key,
    required this.activeLayer,
    required this.onLayerSelected,
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
                Switch(
                  value: ref.watch(markersVisibleProvider),
                  onChanged: ref
                      .read(markersVisibleProvider.notifier)
                      .setMarkersVisible,
                ),
              ],
            ),
            if (ref.read(overlayUrlProvider) != '')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Show Overlay'),
                  Switch(
                    value: ref.watch(overlayActiveProvider),
                    onChanged: ref
                        .read(overlayActiveProvider.notifier)
                        .setPmtiles,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
