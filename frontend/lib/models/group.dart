class Group {
  final String groupId;
  final String name;
  final String role;
  final String? description;
  final DateTime createdAt;

  Group({
    required this.groupId,
    required this.name,
    required this.role,
    this.description,
    required this.createdAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    groupId: json['group_id'],
    name: json['name'],
    role: json['role'],
    description: json['description'],
    createdAt: DateTime.parse(json['created_at']),
  );
}
