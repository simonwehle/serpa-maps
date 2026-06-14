import 'package:serpa_maps/models/role.dart';

class Member {
  final String userId;
  final String username;
  final Role role;
  final DateTime? joinedAt;

  Member({
    required this.userId,
    required this.username,
    required this.role,
    this.joinedAt,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      userId: (json['user_id']).toString(),
      username: (json['username']).toString(),
      role: Role.fromString(json['role'] as String),
      joinedAt: DateTime.tryParse(json['joined_at'] ?? ''),
    );
  }
}
