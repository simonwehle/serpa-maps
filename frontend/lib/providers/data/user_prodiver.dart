import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/models/user.dart';

import 'package:serpa_maps/providers/api/api_provider.dart';
import 'package:serpa_maps/providers/data/category_provider.dart';
import 'package:serpa_maps/providers/data/place_provider.dart';
import 'package:serpa_maps/providers/token/access_token_provider.dart';
import 'package:serpa_maps/providers/token/refresh_token_provider.dart';

final userProvider = AsyncNotifierProvider<UserNotifier, User?>(
  UserNotifier.new,
);

class UserNotifier extends AsyncNotifier<User?> {
  @override
  Future<User> build() async {
    final api = ref.read(apiServiceProvider);
    return await api.me();
  }

  Future<void> setTokens(String accessToken, String refreshToken) async {
    await ref.read(accessTokenProvider.notifier).setToken(accessToken);
    await ref.read(refreshTokenProvider.notifier).setToken(refreshToken);
  }

  void invalidateProviders() {
    ref.invalidate(categoryProvider);
    ref.invalidate(placeProvider);
  }

  Future<User> login({required String email, required String password}) async {
    final api = ref.read(apiServiceProvider);
    final loginResponse = await api.login(email: email, password: password);
    setTokens(loginResponse.accessToken, loginResponse.refreshToken);
    invalidateProviders();
    final user = User(
      userId: loginResponse.userId,
      name: loginResponse.username,
      email: loginResponse.email,
    );
    state = AsyncValue.data(user);
    return user;
  }

  Future<User> register({
    required String email,
    required String name,
    required String password,
  }) async {
    final api = ref.read(apiServiceProvider);
    final registerResponse = await api.register(
      email: email,
      name: name,
      password: password,
    );
    setTokens(registerResponse.accessToken, registerResponse.refreshToken);
    invalidateProviders();
    final user = User(
      email: registerResponse.email,
      name: name,
      userId: registerResponse.userId,
    );
    state = AsyncValue.data(user);
    return user;
  }

  Future<void> logout() async {
    final api = ref.read(apiServiceProvider);
    final refreshToken = ref.read(refreshTokenProvider);
    //TODO: make refreshToken not nullable
    if (refreshToken != null) await api.logout(refreshToken: refreshToken);
    state = const AsyncValue.data(null);
  }
}
