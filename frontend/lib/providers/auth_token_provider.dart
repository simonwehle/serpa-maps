import 'package:flutter_riverpod/flutter_riverpod.dart';

final authTokenProvider = NotifierProvider<AuthTokenNotifier, String?>(
  AuthTokenNotifier.new,
);

class AuthTokenNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  void setToken(String token) {
    state = token;
  }

  void clearToken() {
    state = null;
  }

  bool get isAuthenticated => state != null;
}
