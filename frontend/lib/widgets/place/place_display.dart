import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/widgets/category/category_icon.dart';
import 'package:serpa_maps/widgets/place/place_asset_gallery.dart';
import 'package:serpa_maps/widgets/sheets/sheet_header.dart';
import 'package:map_launcher/map_launcher.dart'; // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

class PlaceDisplay extends ConsumerWidget {
  final Category category;
  final Place place;
  final Function toggleEditing;

  const PlaceDisplay({
    super.key,
    required this.category,
    required this.place,
    required this.toggleEditing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i10n = AppLocalizations.of(context)!;
    Future<void> openMaps(
      double latitude,
      double longitude,
      String title,
    ) async {
      final availableMaps = await MapLauncher.installedMaps;
      await availableMaps.first.showDirections(
        destination: Coords(latitude, longitude),
        destinationTitle: title,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SheetHeader(title: place.name, onPressed: () => toggleEditing()),
          const SizedBox(height: 8),
          Row(
            children: [
              CategoryIcon(category: category),
              const SizedBox(width: 8),
              Text(
                category.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          place.assets.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: PlaceAssetGallery(assets: place.assets),
                )
              : SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton(
              onPressed: () =>
                  openMaps(place.latitude, place.longitude, place.name),
              child: Text(i10n.directions),
            ),
          ),
          Text(
            place.description?.isNotEmpty == true
                ? place.description!
                : AppLocalizations.of(context)!.noDescription,
          ),
          const SizedBox(height: 16),
          Text("${place.latitude.toString()}, ${place.longitude.toString()}"),
        ],
      ),
    );
  }
}
