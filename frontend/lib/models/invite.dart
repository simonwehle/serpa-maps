class Invite {
  final String groupInviteId;
  final String groupId;
  final String groupName;
  final String invitedById;
  final String invitedByUsername;
  final String status;
  final DateTime createdAt;
  DateTime? respondedAt;

  Invite({
    required this.groupInviteId,
    required this.groupId,
    required this.groupName,
    required this.invitedById,
    required this.invitedByUsername,
    required this.status,
    required this.createdAt,
    this.respondedAt,
  });

  factory Invite.fromJson(Map<String, dynamic> json) => Invite(
    groupInviteId: json['group_invite_id'],
    groupId: json['group_id'],
    groupName: json['group_name'],
    invitedById: json['invited_by_id'],
    invitedByUsername: json['invited_by_username'],
    status: json['status'],
    createdAt: DateTime.parse(json['created_at']),
    respondedAt: json['responded_at'] != null
        ? DateTime.parse(json['responded_at'])
        : null,
  );
}
