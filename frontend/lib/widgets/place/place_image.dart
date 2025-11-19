import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/image_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PlaceImage extends ConsumerWidget {
  final String url;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const PlaceImage({
    super.key,
    required this.url,
    this.width = 200,
    this.height = 200,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageAsync = ref.watch(imageProvider(url));

    return Skeletonizer(
      enabled: imageAsync.isLoading,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: imageAsync.when(
          loading: () => Container(
            width: width,
            height: height,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          error: (_, _) => Container(
            width: width,
            height: height,
            color: Theme.of(context).colorScheme.outlineVariant,
            child: const Icon(Icons.broken_image),
          ),
          data: (bytes) =>
              Image.memory(bytes, width: width, height: height, fit: fit),
        ),
      ),
    );
  }
}
