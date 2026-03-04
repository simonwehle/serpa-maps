import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/category_provider.dart';
import 'package:serpa_maps/providers/place_provider.dart';
import 'package:serpa_maps/providers/secure_storage_provider.dart';

final authTokenProvider = NotifierProvider<AuthTokenNotifier, String?>(
  AuthTokenNotifier.new,
);

class AuthTokenNotifier extends Notifier<String?> {
  static const String _tokenKey = 'auth_token';

  @override
  String? build() {
    return null;
  }

  Future<void> loadToken() async {
    final secureStorage = ref.read(secureStorageProvider);
    final token = await secureStorage.read(key: _tokenKey);
    if (token != null) {
      state = token;
    }
  }

  Future<void> setToken(String token) async {
    state = token;
    final secureStorage = ref.read(secureStorageProvider);
    await secureStorage.write(key: _tokenKey, value: token);
  }

  Future<void> logout() async {
    state = null;
    final secureStorage = ref.read(secureStorageProvider);
    await secureStorage.delete(key: _tokenKey);
    ref.invalidate(categoryProvider);
    ref.invalidate(placeProvider);
  }

  bool get isAuthenticated => state != null;
}
