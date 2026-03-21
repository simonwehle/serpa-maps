import 'package:flutter/material.dart';
import 'package:serpa_maps/models/asset.dart';
import 'package:serpa_maps/widgets/place/place_asset_base.dart';

class PlaceVideoPreview extends StatelessWidget {
  final Asset asset;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const PlaceVideoPreview({
    super.key,
    required this.asset,
    this.width = kPlaceAssetWidth,
    this.height = kPlaceAssetHeight,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return PlaceAssetBase(
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      overlay: Center(
        child: Icon(
          Icons.play_circle_fill,
          size: 48,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      child: Image.network(
        asset.assetUrl,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Center(child: Icon(Icons.broken_image));
        },
      ),
    );
  }
}
