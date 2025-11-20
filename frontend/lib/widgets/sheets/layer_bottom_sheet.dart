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
    return SerpaStaticSheet(
      title: 'Map Layer',
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LayerImage(
                name: 'Default',
                assetImage: AssetImage('assets/default.jpg'),
              ),
              LayerImage(
                name: 'Explore',
                assetImage: AssetImage('assets/explore.jpg'),
              ),
              LayerImage(
                name: 'Satellite',
                assetImage: AssetImage('assets/satellite.jpg'),
              ),
            ],
          ),
          SegmentedButton<MapLayer>(
            segments: <ButtonSegment<MapLayer>>[
              ButtonSegment(
                value: MapLayer.vector,
                label: Text(AppLocalizations.of(context)!.defaultMap),
              ),
              ButtonSegment(
                value: MapLayer.osm,
                label: Text(AppLocalizations.of(context)!.explore),
              ),
              ButtonSegment(
                value: MapLayer.satellite,
                label: Text(AppLocalizations.of(context)!.satellite),
              ),
            ],
            selected: <MapLayer>{ref.watch(activeLayerProvider)},
            onSelectionChanged: (Set<MapLayer> newSelection) {
              if (newSelection.isNotEmpty) {
                final newLayer = newSelection.first;
                ref.read(activeLayerProvider.notifier).setActiveLayer(newLayer);
              }
            },
            showSelectedIcon: false,
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
