import 'package:flutter/material.dart';

enum Role {
  admin,
  editor,
  member,
  pending;

  String get label => switch (this) {
    Role.admin => 'Admin',
    Role.editor => 'Editor',
    Role.member => 'Member',
    Role.pending => 'Pending',
  };

  IconData get icon => switch (this) {
    Role.admin => Icons.security,
    Role.editor => Icons.edit,
    Role.member => Icons.visibility,
    Role.pending => Icons.send,
  };

  static Role fromString(String value) => switch (value.toLowerCase()) {
    'admin' => Role.admin,
    'editor' => Role.editor,
    'member' => Role.member,
    'pending' => Role.pending,
    _ => Role.member,
  };
}
