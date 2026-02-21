import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/auth_token_provider.dart';
import 'package:serpa_maps/providers/base_url_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = ref.watch(baseUrlProvider);
  final authToken = ref.watch(authTokenProvider);
  final fallbackUrl = "http://localhost:53164";
  final effectiveUrl = baseUrl.isNotEmpty ? baseUrl : fallbackUrl;

  final dio = Dio(
    BaseOptions(
      baseUrl: '$effectiveUrl/api/v1',
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  // Add auth token interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (authToken != null) {
          options.headers['Authorization'] = 'Bearer $authToken';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        // You can add global error handling here
        // e.g., auto-logout on 401, retry logic, etc.
        return handler.next(error);
      },
    ),
  );

  return dio;
});
