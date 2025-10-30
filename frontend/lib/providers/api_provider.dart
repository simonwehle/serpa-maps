import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:serpa_maps/services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final baseUrl = dotenv.env['BASE_URL'] ?? "http://localhost:3465";
  return ApiService(baseUrl, apiVersion: '/api/v1');
});
