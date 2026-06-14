import 'package:serpa_maps/models/role.dart';

class Group {
  final String groupId;
  final String name;
  final Role role;
  final String? description;
  final DateTime createdAt;

  Group({
    required this.groupId,
    required this.name,
    required this.role,
    this.description,
    required this.createdAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    final createdAtRaw = json['created_at'] ?? json['createdAt'];

    return Group(
      groupId: (json['group_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      role: Role.fromString(json['role'] as String),
      description: json['description']?.toString(),
      createdAt: createdAtRaw is String && createdAtRaw.isNotEmpty
          ? DateTime.parse(createdAtRaw)
          : DateTime.now(),
    );
  }
}
