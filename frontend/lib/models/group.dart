class Group {
  final String groupId;
  final String name;
  final String? description;
  final DateTime createdAt;

  Group({
    required this.groupId,
    required this.name,
    this.description,
    required this.createdAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    groupId: json['group_id'],
    name: json['name'],
    description: json['description'],
    createdAt: DateTime.parse(json['created_at']),
  );
}
