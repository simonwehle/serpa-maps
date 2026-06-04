import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/models/user.dart';

import 'package:serpa_maps/providers/api/api_provider.dart';
import 'package:serpa_maps/providers/token/access_token_provider.dart';
import 'package:serpa_maps/providers/token/refresh_token_provider.dart';

final userProvider = AsyncNotifierProvider<UserNotifier, User?>(
  UserNotifier.new,
);

class UserNotifier extends AsyncNotifier<User?> {
  @override
  Future<User> build() async {
    final api = ref.read(apiServiceProvider);
    return api.me();
  }

  Future<void> setTokens(String accessToken, String refreshToken) async {
    await ref.read(accessTokenProvider.notifier).setToken(accessToken);
    await ref.read(refreshTokenProvider.notifier).setToken(refreshToken);
  }

  Future<User> login({required String email, required String password}) async {
    final api = ref.read(apiServiceProvider);
    final loginResponse = await api.login(email: email, password: password);
    await setTokens(loginResponse.accessToken, loginResponse.refreshToken);
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
      username: name,
      password: password,
    );
    await setTokens(
      registerResponse.accessToken,
      registerResponse.refreshToken,
    );
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
    await ref.read(accessTokenProvider.notifier).clearToken();
    await ref.read(refreshTokenProvider.notifier).clearToken();
    state = const AsyncValue.data(null);
  }
}
