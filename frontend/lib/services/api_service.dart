import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place.dart';
import '../models/category.dart';

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

  Future<Place> updatePlace(
    int id, {
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
}
