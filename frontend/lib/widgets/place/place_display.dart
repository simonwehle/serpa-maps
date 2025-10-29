import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/utils/icon_color_utils.dart';
import 'package:serpa_maps/widgets/place/place_assets.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                place.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => toggleEditing(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: colorFromHex(category.color),
                child: Icon(iconFromString(category.icon), color: Colors.white),
              ),
              const SizedBox(width: 8),
              Text(
                category.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        PlaceAssets(place: place),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            place.description?.isNotEmpty == true
                ? place.description!
                : 'Keine Beschreibung verfügbar.',
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "${place.latitude.toString()}, ${place.longitude.toString()}",
          ),
        ),
      ],
    );
  }
}
