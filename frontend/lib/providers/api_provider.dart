import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/baseurl_provider.dart';
import 'package:serpa_maps/services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final baseUrl = ref.read(baseUrlProvider);
  return ApiService(baseUrl, apiVersion: '/api/v1');
});
