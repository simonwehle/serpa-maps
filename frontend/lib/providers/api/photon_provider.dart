import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/providers/preferences/geoencoding_url_provider.dart';
import 'package:serpa_maps/services/photon_service.dart';

final _photonDioProvider = Provider<Dio>((ref) {
  final geoencodingUrl = ref.watch(geoencodingUrlProvider);

  return Dio(
    BaseOptions(
      headers: {'User-Agent': 'Serpa Maps'},
      baseUrl: geoencodingUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );
});

final photonSearchProvider = FutureProvider.family<List<Place>, String>((
  ref,
  query,
) async {
  if (query.isEmpty) {
    return [];
  }

  final photonDio = ref.watch(_photonDioProvider);
  final photonService = PhotonService(photonDio);

  return photonService.search(query);
});
