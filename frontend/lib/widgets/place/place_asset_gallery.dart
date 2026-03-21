import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:serpa_maps/models/asset.dart';
import 'package:serpa_maps/providers/data/place_provider.dart';
import 'package:serpa_maps/widgets/place/place_asset_base.dart';
import 'package:serpa_maps/widgets/place/place_assets_fullscreen.dart';
import 'package:serpa_maps/widgets/place/place_image.dart';
import 'package:serpa_maps/widgets/place/place_video_thumbnail.dart';

class PlaceAssetGallery extends ConsumerWidget {
  final List<Asset> assets;
  final bool isEditing;
  final VoidCallback? onAddImage;

  const PlaceAssetGallery({
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
                return PlaceAssetBase(
                  width: kPlaceAssetWidth,
                  height: kPlaceAssetHeight,
                  borderRadius: BorderRadius.circular(8),
                  overlay: GestureDetector(
                    onTap: onAddImage,
                    child: Center(
                      child: Icon(
                        Icons.add_a_photo,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ),
                  child: Container(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                );
              }

              final asset = assets[index];
              final child = asset.isVideo
                  ? PlaceVideoPreview(asset: asset)
                  : PlaceImage(
                      asset: asset,
                      isEditing: isEditing,
                      onDelete: () {
                        ref
                            .read(placeProvider.notifier)
                            .deleteAsset(
                              placeId: asset.placeId,
                              assetId: asset.assetId,
                            )
                            .catchError((_) {});
                      },
                    );
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
                child: child,
              );
            },
            separatorBuilder: (_, _) => const SizedBox(width: 8),
          ),
        ),
      ],
    );
  }
}
