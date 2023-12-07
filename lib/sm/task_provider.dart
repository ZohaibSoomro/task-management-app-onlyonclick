import 'package:flutter/foundation.dart';
import 'package:task_management_app_onlyonclick/models/task.dart';
import 'package:task_management_app_onlyonclick/utils/firebase_helper.dart';

class TasksProvider extends ChangeNotifier {
  List<Task> tasks = [];

  Future<List<Task>> loadTasks() async {
    final taskList = await FirebaseHelper.instance.loadTasks();
    if (taskList.isNotEmpty) {
      tasks = taskList;
      notifyListeners();
    }
    return tasks;
  }
}
