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
    final i10n = AppLocalizations.of(context)!;

    return SerpaStaticSheet(
      title: i10n.mapLayer,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LayerImage(
                name: i10n.defaultMap,
                assetImage: AssetImage('assets/layers/default.jpg'),
                isActive: activeLayer == MapLayer.vector,
                onTap: () => ref
                    .read(activeLayerProvider.notifier)
                    .setActiveLayer(MapLayer.vector),
              ),
              LayerImage(
                name: i10n.satellite,
                assetImage: AssetImage('assets/layers/satellite.jpg'),
                isActive: activeLayer == MapLayer.satellite,
                onTap: () => ref
                    .read(activeLayerProvider.notifier)
                    .setActiveLayer(MapLayer.satellite),
              ),
              LayerImage(
                name: i10n.explore,
                assetImage: AssetImage('assets/layers/explore.jpg'),
                isActive: activeLayer == MapLayer.osm,
                onTap: () => ref
                    .read(activeLayerProvider.notifier)
                    .setActiveLayer(MapLayer.osm),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(i10n.showMarkers),
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
                Text(i10n.showOverlay),
                Switch(
                  value: ref.watch(overlayActiveProvider),
                  onChanged: ref
                      .read(overlayActiveProvider.notifier)
                      .setOverlayActive,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
