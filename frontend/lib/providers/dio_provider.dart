import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/token/access_token_provider.dart';
import 'package:serpa_maps/providers/base_url_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = ref.watch(baseUrlProvider);
  final authToken = ref.watch(accessTokenProvider);
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

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (authToken != null) {
          options.headers['Authorization'] = 'Bearer $authToken';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          final currentToken = ref.read(accessTokenProvider);
          if (currentToken != null) {
            ref.read(accessTokenProvider.notifier).clearToken();
          }
        }
        return handler.next(error);
      },
    ),
  );

  return dio;
});
