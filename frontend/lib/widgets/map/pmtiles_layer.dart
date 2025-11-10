import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:serpa_maps/providers/pmtiles_active_prvoiders.dart';
import 'package:serpa_maps/providers/pmtiles_provider.dart';

class PmtilesLayer extends ConsumerWidget {
  const PmtilesLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pmtiles = ref.read(pmtilesProvider);
    if (pmtiles != '') {
      if (ref.watch(pmTilesActiveProvider)) {
        return TileLayer(
          urlTemplate: ref.read(pmtilesProvider),
          userAgentPackageName: 'org.serpamaps',
        );
      } else {
        return const SizedBox.shrink();
      }
    }
    return const SizedBox.shrink();
  }
}
