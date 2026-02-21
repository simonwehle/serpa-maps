import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/auth_token_provider.dart';
import 'package:serpa_maps/providers/base_url_provider.dart';
import 'package:serpa_maps/services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final baseUrl = ref.watch(baseUrlProvider);
  final authToken = ref.watch(authTokenProvider);
  final fallbackUrl = "http://localhost:53164";
  final effectiveUrl = baseUrl.isNotEmpty ? baseUrl : fallbackUrl;
  return ApiService(effectiveUrl, apiVersion: '/api/v1', authToken: authToken);
});
