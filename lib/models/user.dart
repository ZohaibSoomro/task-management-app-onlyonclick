import 'package:encrypt/encrypt.dart';

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
      'password': encryptPassword(email, password),
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      type:
          json['type'] == UserType.admin.name ? UserType.admin : UserType.user,
      name: json['name'],
      email: json['email'],
      password: decryptPassword(json['email'], json['password']),
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

String encryptPassword(String email, String password) {
  return Encrypter(AES(Key.fromUtf8(email))).encrypt(password).base64;
}

String decryptPassword(String email, String hashedPassword) {
  return Encrypter(AES(Key.fromUtf8(email)))
      .decrypt(Encrypted.fromBase64(hashedPassword));
}
