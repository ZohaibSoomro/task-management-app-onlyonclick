class Task {
  String title;
  String description;
  DateTime deadline;
  bool isCompleted;

  Task({
    this.isCompleted = false,
    this.description = "",
    required this.deadline,
    required this.title,
  });
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      deadline: DateTime.parse(json['deadline']),
      isCompleted: json['isCompleted'],
    );
  }
}
