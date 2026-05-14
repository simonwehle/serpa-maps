import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/api/api_provider.dart';

typedef AssetRequest = ({String placeId, String assetId});

final assetProvider = FutureProvider.family<Uint8List, AssetRequest>((
  ref,
  request,
) async {
  final api = ref.read(apiServiceProvider);
  return api.fetchAssetBytes(
    placeId: request.placeId,
    assetId: request.assetId,
  );
});
