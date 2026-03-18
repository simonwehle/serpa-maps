import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/data/category_provider.dart';
import 'package:serpa_maps/providers/data/place_provider.dart';
import 'package:serpa_maps/providers/token/secure_storage_provider.dart';

class TokenNotifier extends Notifier<String?> {
  final String tokenKey;

  TokenNotifier(this.tokenKey);

  @override
  String? build() {
    return null;
  }

  Future<void> loadToken() async {
    final secureStorage = ref.read(secureStorageProvider);
    final token = await secureStorage.read(key: tokenKey);
    if (token != null) {
      state = token;
    }
  }

  Future<void> setToken(String token) async {
    state = token;
    final secureStorage = ref.read(secureStorageProvider);
    await secureStorage.write(key: tokenKey, value: token);
  }

  Future<void> clearToken() async {
    state = null;
    final secureStorage = ref.read(secureStorageProvider);
    await secureStorage.delete(key: tokenKey);
    ref.invalidate(categoryProvider);
    ref.invalidate(placeProvider);
  }

  bool get isAuthenticated => state != null;
}
