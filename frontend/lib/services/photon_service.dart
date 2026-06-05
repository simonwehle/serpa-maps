import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:serpa_maps/models/place.dart';

class PhotonService {
  final Dio _dio;

  PhotonService(this._dio);

  Future<List<Place>> search(String query) async {
    if (query.isEmpty) {
      return [];
    }

    try {
      final response = await _dio.get('/api', queryParameters: {'q': query});

      final data = response.data;
      final features = data['features'] as List;

      return features.map((feature) {
        final properties = feature['properties'];
        final coordinates = feature['geometry']['coordinates'];
        final addressParts = [
          properties['street'],
          properties['city'],
          properties['country'],
        ].where((part) => part != null && part.isNotEmpty).toList();
        return Place(
          id:
              properties['osm_id']?.toString() ??
              DateTime.now().toIso8601String(),
          name: properties['name'] ?? 'Unknown name',
          description: addressParts.join(', '),
          latitude: coordinates[1],
          longitude: coordinates[0],
          categoryId: 'photon-search-result',
          assets: [],
          groupIds: [],
          createdAt: DateTime.now(),
        );
      }).toList();
    } on DioException catch (e) {
      debugPrint('DioException during Photon search: ${e.message}');
      debugPrint('URL: ${e.requestOptions.uri}');
      if (e.response != null) {
        debugPrint('Response data: ${e.response?.data}');
      }
      throw Exception('Failed to load search results: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected error during Photon search: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
