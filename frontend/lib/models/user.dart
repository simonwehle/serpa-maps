class User {
  final int userId;
  final String name;
  final String email;
  final DateTime createdAt;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json['user_id'],
    name: json['name'],
    email: json['email'],
    createdAt: DateTime.parse(json['created_at']),
  );
}
