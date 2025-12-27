import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';

class ApiService {
  final String baseUrl;
  final String apiVersion;

  ApiService(this.baseUrl, {this.apiVersion = '/api/v1'});

  String _endpoint(String path) => '$baseUrl$apiVersion$path';

  Future<List<Category>> fetchCategories() async {
    final res = await http.get(Uri.parse(_endpoint('/categories')));
    if (res.statusCode != 200) throw Exception('Failed to load categories');
    final List data = json.decode(res.body);
    return data.map((json) => Category.fromJson(json)).toList();
  }

  Future<List<Place>> fetchPlaces() async {
    final res = await http.get(Uri.parse(_endpoint('/places')));
    if (res.statusCode != 200) throw Exception('Failed to load places');
    final List data = json.decode(res.body);
    return data.map((json) => Place.fromJson(json)).toList();
  }

  Future<Place> updatePlace({
    required int id,
    String? name,
    String? description,
    double? latitude,
    double? longitude,
    int? categoryId,
  }) async {
    final Map<String, dynamic> updates = {};

    if (name != null) updates['name'] = name;
    if (description != null) updates['description'] = description;
    if (latitude != null) updates['latitude'] = latitude;
    if (longitude != null) updates['longitude'] = longitude;
    if (categoryId != null) updates['category_id'] = categoryId;

    if (updates.isEmpty) {
      throw Exception('No fields to update');
    }

    final res = await http.patch(
      Uri.parse(_endpoint('/place/$id')),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updates),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to update place: ${res.body}');
    }

    final data = json.decode(res.body);
    return Place.fromJson(data);
  }

  Future<Place?> addPlace({
    required String name,
    required double latitude,
    required double longitude,
    required int categoryId,
    String? description,
  }) async {
    final Map<String, dynamic> newRoom = {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'category_id': categoryId,
    };

    if (description != null) newRoom['description'] = description;

    final res = await http.post(
      Uri.parse(_endpoint('/place')),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newRoom),
    );

    if (res.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(res.body);
      return Place.fromJson(data);
    } else {
      throw Exception('Failed to add place. Status code: ${res.statusCode}');
    }
  }

  Future<void> deletePlace({required int id}) async {
    final res = await http.delete(Uri.parse(_endpoint('/place/$id')));

    if (res.statusCode != 200) {
      throw Exception('Failed to delete place. Status code: ${res.statusCode}');
    }
  }

  Future<void> deleteAsset({required int placeId, required int assetId}) async {
    final res = await http.delete(
      Uri.parse(_endpoint('/place/$placeId/asset/$assetId')),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to delete asset. Status code: ${res.statusCode}');
    }
  }
}
