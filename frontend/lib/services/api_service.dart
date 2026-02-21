import 'dart:async';
import 'package:dio/dio.dart';

import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/models/auth.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<List<Category>> fetchCategories() async {
    final res = await _dio.get('/categories');
    final List data = res.data;
    return data.map((json) => Category.fromJson(json)).toList();
  }

  Future<List<Place>> fetchPlaces() async {
    final res = await _dio.get('/places');
    final List data = res.data;
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

    final res = await _dio.patch('/place/$id', data: updates);
    return Place.fromJson(res.data);
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

    final res = await _dio.post('/place', data: newRoom);
    return Place.fromJson(res.data);
  }

  Future<void> deletePlace({required int id}) async {
    await _dio.delete('/place/$id');
  }

  Future<void> deleteAsset({required int placeId, required int assetId}) async {
    await _dio.delete('/place/$placeId/asset/$assetId');
  }

  Future<List<dynamic>> uploadAsset({
    required int placeId,
    required List<int> assetBytes,
    required String filename,
  }) async {
    final formData = FormData.fromMap({
      'assets': MultipartFile.fromBytes(assetBytes, filename: filename),
    });

    final res = await _dio.post('/place/$placeId/assets', data: formData);
    return res.data['assets'];
  }

  Future<Category?> addCategory({
    required String name,
    required String icon,
    required String color,
  }) async {
    final Map<String, dynamic> newCategory = {
      'name': name,
      'icon': icon,
      'color': color,
    };

    final res = await _dio.post('/category', data: newCategory);
    return Category.fromJson(res.data);
  }

  Future<Category> updateCategory({
    required int id,
    String? name,
    String? icon,
    String? color,
  }) async {
    final Map<String, dynamic> updates = {};

    if (name != null) updates['name'] = name;
    if (icon != null) updates['icon'] = icon;
    if (color != null) updates['color'] = color;

    if (updates.isEmpty) {
      throw Exception('No fields to update');
    }

    final res = await _dio.patch('/category/$id', data: updates);
    return Category.fromJson(res.data);
  }

  Future<void> deleteCategory({required int id}) async {
    await _dio.delete('/category/$id');
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> loginRequest = {
      'email': email,
      'password': password,
    };

    final res = await _dio.post('/login', data: loginRequest);
    return AuthResponse.fromJson(res.data);
  }

  Future<AuthResponse> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> registerRequest = {
      'email': email,
      'username': username,
      'password': password,
    };

    final res = await _dio.post('/register', data: registerRequest);
    return AuthResponse.fromJson(res.data);
  }
}
