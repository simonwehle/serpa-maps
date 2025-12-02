import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:serpa_maps/models/asset.dart';
import 'package:serpa_maps/widgets/place/place_image.dart';

class PlaceAssets extends ConsumerWidget {
  final List<Asset> assets;

  const PlaceAssets({super.key, required this.assets});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (assets.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: assets.length,
            itemBuilder: (context, index) {
              final asset = assets[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: PlaceImage(url: asset.assetUrl),
              );
            },
            separatorBuilder: (_, _) => const SizedBox(width: 8),
          ),
        ),
      ],
    );
  }
}
