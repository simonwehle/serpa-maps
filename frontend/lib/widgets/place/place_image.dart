import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/image_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PlaceImage extends ConsumerWidget {
  final String url;
  const PlaceImage({super.key, required this.url});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageAsync = ref.watch(imageProvider(url));

    return Skeletonizer(
      enabled: imageAsync.isLoading,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageAsync.when(
          loading: () => Container(
            width: 200,
            height: 200,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          error: (_, _) => Container(
            width: 200,
            height: 200,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image),
          ),
          data: (bytes) =>
              Image.memory(bytes, width: 200, height: 200, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
