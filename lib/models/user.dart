import 'dart:convert';

class User {
  UserType type;
  String name;
  String email;
  String password;
  int tasksCount;
  User({
    required this.type,
    required this.name,
    required this.email,
    required this.password,
    this.tasksCount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'name': name,
      'email': email,
      'tasksCount': tasksCount,
      'password': _encryptPassword(password),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      type:
          json['type'] == UserType.admin.name ? UserType.admin : UserType.user,
      name: json['name'],
      email: json['email'],
      tasksCount: json['tasksCount'],
      password: _decryptPassword(json['password']),
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
