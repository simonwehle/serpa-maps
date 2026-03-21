import 'package:flutter/material.dart';

const double kPlaceAssetWidth = 200;
const double kPlaceAssetHeight = 150;

class PlaceAssetBase extends StatelessWidget {
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget child;
  final Widget? overlay;

  const PlaceAssetBase({
    super.key,
    this.width = kPlaceAssetWidth,
    this.height = kPlaceAssetHeight,
    this.fit = BoxFit.cover,
    this.borderRadius,
    required this.child,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: Container(
        width: width,
        height: height,
        color: Theme.of(context).colorScheme.outlineVariant,
        child: Stack(
          fit: StackFit.expand,
          children: [child, if (overlay != null) overlay!],
        ),
      ),
    );
  }
}
