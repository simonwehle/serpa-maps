import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/widgets/category/category_icon.dart';
import 'package:serpa_maps/widgets/place/place_assets.dart';
import 'package:serpa_maps/widgets/sheets/sheet_header.dart';

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
          const SizedBox(height: 16),
          PlaceAssets(assets: place.assets),
          if (place.assets.isNotEmpty) const SizedBox(height: 16),
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
