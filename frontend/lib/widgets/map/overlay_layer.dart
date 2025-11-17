import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:serpa_maps/providers/overlay_active_prvoider.dart';
import 'package:serpa_maps/providers/overlay_url_provider.dart';

class OverlayLayer extends ConsumerWidget {
  const OverlayLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overlayUrl = ref.read(overlayUrlProvider);
    if (overlayUrl != '') {
      if (ref.watch(overlayActiveProvider)) {
        return TileLayer(urlTemplate: overlayUrl);
      } else {
        return const SizedBox.shrink();
      }
    }
    return const SizedBox.shrink();
  }
}
