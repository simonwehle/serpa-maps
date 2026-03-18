import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/token/access_token_provider.dart';
import 'package:serpa_maps/providers/token/refresh_token_provider.dart';
import 'package:serpa_maps/providers/url/base_url_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = ref.watch(baseUrlProvider);
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

  Future<String?>? ongoingRefresh;

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (!options.path.contains('/logout') &&
            !options.path.contains('/refresh')) {
          final authToken = ref.read(accessTokenProvider);
          if (authToken != null) {
            options.headers['Authorization'] = 'Bearer $authToken';
          }
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401 &&
            !error.requestOptions.path.contains('/refresh') &&
            !error.requestOptions.path.contains('/logout')) {
          final refreshToken = ref.read(refreshTokenProvider);
          if (refreshToken == null) {
            ref.read(accessTokenProvider.notifier).clearToken();
            return handler.next(error);
          }

          try {
            ongoingRefresh ??= _performRefresh(ref, effectiveUrl, refreshToken);
            final newAccessToken = await ongoingRefresh;
            ongoingRefresh = null;

            if (newAccessToken != null) {
              final headers = Map<String, dynamic>.from(
                error.requestOptions.headers,
              );
              headers.remove('Authorization');

              final opts = Options(
                method: error.requestOptions.method,
                headers: headers,
              );
              final response = await dio.request(
                error.requestOptions.path,
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
                options: opts,
              );
              return handler.resolve(response);
            }
          } catch (e) {
            ongoingRefresh = null;
            ref.read(accessTokenProvider.notifier).clearToken();
            ref.read(refreshTokenProvider.notifier).clearToken();
          }
        }
        return handler.next(error);
      },
    ),
  );

  return dio;
});

Future<String?> _performRefresh(
  Ref ref,
  String baseUrl,
  String refreshToken,
) async {
  final refreshDio = Dio(BaseOptions(baseUrl: '$baseUrl/api/v1'));

  try {
    final response = await refreshDio.post(
      '/refresh',
      data: {'refresh_token': refreshToken},
    );

    final newAccessToken = response.data['access_token'] as String;
    await ref.read(accessTokenProvider.notifier).setToken(newAccessToken);
    return newAccessToken;
  } catch (e) {
    return null;
  }
}
