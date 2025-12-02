import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/image_provider.dart';
import 'package:serpa_maps/widgets/sheets/sheet_button.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PlaceImage extends ConsumerWidget {
  final String url;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool isEditing;

  const PlaceImage({
    super.key,
    required this.url,
    this.width = 200,
    this.height = 200,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageAsync = ref.watch(imageProvider(url));

    return Skeletonizer(
      enabled: imageAsync.isLoading,
      child: Stack(
        children: [
          ClipRRect(
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
          if (isEditing)
            Positioned(
              top: 6,
              right: 6,
              child: SheetButton(
                icon: Icons.close,
                onPressed: () => print("Delete button pressed"),
              ),
            ),
        ],
      ),
    );
  }
}
