import 'package:task_management_app_onlyonclick/models/user.dart';

class Task {
  String title;
  String description;
  DateTime deadline;
  bool isCompleted;
  User user;

  Task({
    this.isCompleted = false,
    this.description = "",
    required this.deadline,
    required this.title,
    required this.user,
  });
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'deadline': deadline.toString(),
      'isCompleted': isCompleted,
      'user': user.toJson(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      deadline: DateTime.parse(json['deadline']),
      isCompleted: json['isCompleted'],
      user: User.fromJson(json['user']),
    );
  }
}
