import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/providers/map_layer_provider.dart';
import 'package:serpa_maps/providers/markers_visible_provider.dart';
import 'package:serpa_maps/providers/overlay_active_prvoider.dart';
import 'package:serpa_maps/providers/overlay_url_provider.dart';
import 'package:serpa_maps/widgets/layer/layer_image.dart';
import 'package:serpa_maps/widgets/sheets/serpa_static_sheet.dart';

class LayerBottomSheet extends ConsumerWidget {
  const LayerBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLayer = ref.watch(activeLayerProvider);

    return SerpaStaticSheet(
      title: 'Map Layer',
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => ref
                    .read(activeLayerProvider.notifier)
                    .setActiveLayer(MapLayer.vector),
                child: LayerImage(
                  name: 'Default',
                  assetImage: AssetImage('assets/default.jpg'),
                  borderColor: activeLayer == MapLayer.vector
                      ? Colors.blue
                      : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () => ref
                    .read(activeLayerProvider.notifier)
                    .setActiveLayer(MapLayer.osm),
                child: LayerImage(
                  name: 'Explore',
                  assetImage: AssetImage('assets/explore.jpg'),
                  borderColor: activeLayer == MapLayer.osm
                      ? Colors.blue
                      : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () => ref
                    .read(activeLayerProvider.notifier)
                    .setActiveLayer(MapLayer.satellite),
                child: LayerImage(
                  name: 'Satellite',
                  assetImage: AssetImage('assets/satellite.jpg'),
                  borderColor: activeLayer == MapLayer.satellite
                      ? Colors.blue
                      : Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.showMarkers),
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
                Text(AppLocalizations.of(context)!.showOverlay),
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
    );
  }
}
