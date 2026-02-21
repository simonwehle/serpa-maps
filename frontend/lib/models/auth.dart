class AuthResponse {
  final String email;
  final String token;
  final int userId;
  final String username;

  AuthResponse({
    required this.email,
    required this.token,
    required this.userId,
    required this.username,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    email: json['email'],
    token: json['token'],
    userId: json['user_id'],
    username: json['username'],
  );
}
