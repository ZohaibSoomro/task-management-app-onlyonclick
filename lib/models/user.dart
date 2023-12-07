import 'dart:convert';

import 'task.dart';

class User {
  UserType type;
  String name;
  String email;
  String password;
  List<Task> tasks;

  User({
    required this.type,
    required this.name,
    required this.email,
    required this.password,
    this.tasks = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'name': name,
      'email': email,
      'password': _encryptPassword(password),
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      type:
          json['type'] == UserType.admin.name ? UserType.admin : UserType.user,
      name: json['name'],
      email: json['email'],
      password: _decryptPassword(json['password']),
      tasks: (json['tasks'] as List)
          .map((taskJson) => Task.fromJson(taskJson))
          .toList(),
    );
  }
}

enum UserType {
  admin,
  user,
}

String _encryptPassword(String password) {
  return base64Encode(utf8.encode(password));
}

String _decryptPassword(String hashedPassword) {
  return utf8.decode(base64Decode(hashedPassword));
}
