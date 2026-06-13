class Member {
  final String userId;
  final String username;
  final String role;
  final DateTime joinedAt;

  Member({
    required this.userId,
    required this.username,
    required this.role,
    required this.joinedAt,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      userId: (json['userId']).toString(),
      username: (json['username']).toString(),
      role: (json['role']).toString(),
      joinedAt: DateTime.parse(json['joined_at']),
    );
  }
}
