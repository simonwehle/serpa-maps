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
}
