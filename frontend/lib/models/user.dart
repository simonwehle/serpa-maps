class User {
  final String userId;
  final String name;
  final String email;

  User({required this.userId, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(userId: json['user_id'], name: json['name'], email: json['email']);
}
