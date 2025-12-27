import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:serpa_maps/models/asset.dart';
import 'package:serpa_maps/providers/place_provider.dart';
import 'package:serpa_maps/widgets/place/place_assets_fullscreen.dart';
import 'package:serpa_maps/widgets/place/place_image.dart';

class PlaceAssets extends ConsumerWidget {
  final List<Asset> assets;
  final bool isEditing;
  final VoidCallback? onAddImage;

  const PlaceAssets({
    super.key,
    required this.assets,
    this.isEditing = false,
    this.onAddImage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAddButton = onAddImage != null;
    final itemCount = assets.length + (showAddButton ? 1 : 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: kPlaceAssetHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index == assets.length) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: GestureDetector(
                    onTap: onAddImage,
                    child: Container(
                      width: kPlaceAssetWidth,
                      height: kPlaceAssetHeight,
                      color: Theme.of(context).colorScheme.secondary,
                      child: Center(
                        child: Icon(
                          Icons.add_a_photo,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }

              final asset = assets[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PlaceAssetsFullscreen(
                        assets: assets,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
                child: PlaceImage(
                  url: asset.assetUrl,
                  width: kPlaceAssetWidth,
                  height: kPlaceAssetHeight,
                  isEditing: isEditing,
                  onDelete: () async {
                    try {
                      await ref
                          .read(placeProvider.notifier)
                          .deleteAsset(
                            placeId: asset.placeId,
                            assetId: asset.assetId,
                          );
                    } catch (e) {}
                  },
                ),
              );
            },
            separatorBuilder: (_, _) => const SizedBox(width: 8),
          ),
        ),
      ],
    );
  }
}
