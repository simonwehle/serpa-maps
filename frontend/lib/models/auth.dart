class AuthResponse {
  final String email;
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String username;

  AuthResponse({
    required this.email,
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.username,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    email: json['email'],
    accessToken: json['access_token'],
    refreshToken: json['refresh_token'],
    userId: json['user_id'],
    username: json['username'],
  );
}

class AccessToken {
  final String accessToken;

  AccessToken({required this.accessToken});

  factory AccessToken.fromJson(Map<String, dynamic> json) =>
      AccessToken(accessToken: json['access_token']);
}
