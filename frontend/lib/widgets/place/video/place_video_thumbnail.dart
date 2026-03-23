import 'package:flutter/material.dart';
import 'package:serpa_maps/models/asset.dart';
import 'package:serpa_maps/widgets/place/place_asset_base.dart';

class PlaceVideoThumbnail extends StatelessWidget {
  final Asset asset;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const PlaceVideoThumbnail({
    super.key,
    required this.asset,
    this.width = kPlaceAssetWidth,
    this.height = kPlaceAssetHeight,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            asset.assetUrl,
            fit: fit,
            width: width,
            height: height,
            errorBuilder: (context, error, stackTrace) {
              return Center(child: Icon(Icons.broken_image));
            },
          ),
          Center(
            child: Icon(
              Icons.play_circle_fill,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
