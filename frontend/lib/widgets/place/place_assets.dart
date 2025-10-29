import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:serpa_maps/models/asset.dart';
import 'package:serpa_maps/providers/baseurl_provider.dart';

class PlaceAssets extends ConsumerWidget {
  final List<Asset> assets;

  const PlaceAssets({super.key, required this.assets});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseUrl = ref.read(baseUrlProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (assets.isNotEmpty)
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: assets.length,
              itemBuilder: (context, index) {
                final asset = assets[index];
                final url = asset.assetUrl;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      '$baseUrl/$url',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
