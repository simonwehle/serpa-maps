import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place.dart';
import '../models/category.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<List<Category>> fetchCategories() async {
    final res = await http.get(Uri.parse('$baseUrl/api/v1/categories'));
    if (res.statusCode != 200) throw Exception('Failed to load categories');
    final List data = json.decode(res.body);
    return data.map((json) => Category.fromJson(json)).toList();
  }

  Future<List<Place>> fetchPlaces() async {
    final res = await http.get(Uri.parse('$baseUrl/api/v1/places'));
    if (res.statusCode != 200) throw Exception('Failed to load places');
    final List data = json.decode(res.body);
    return data.map((json) => Place.fromJson(json)).toList();
  }
}
