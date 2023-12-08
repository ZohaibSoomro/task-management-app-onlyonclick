import 'package:flutter/foundation.dart';
import 'package:task_management_app_onlyonclick/models/task.dart';
import 'package:task_management_app_onlyonclick/models/user.dart';
import 'package:task_management_app_onlyonclick/utils/firebase_helper.dart';

class TasksProvider extends ChangeNotifier {
  List<Task> tasks = [];
  late String currentUserEmail;
  late UserType currentUserRole;
  final helper = FirebaseHelper.instance;

  Future<List<Task>> loadTasks() async {
    tasks = await helper.getAllTasks();
    if (currentUserRole == UserType.user) {
      tasks =
          tasks.where((task) => task.user.email == currentUserEmail).toList();
    }
    return tasks;
  }

  void setCurrentUser(String email) {
    currentUserEmail = email;
  }

  void setCurrentUserRole(UserType rol) {
    currentUserRole = rol;
  }

  Future<bool?> saveTask(Task task) async {
    task.user.tasksCount++;
    final result = helper.addTask(task);
    helper.updateUser(task.user);
    await loadTasks();
    notifyListeners();
    return result;
  }

  Future<bool?> editTask(int taskDocumentId, Task task) async {
    final result = helper.updateTask(taskDocumentId.toString(), task);
    await loadTasks();
    notifyListeners();
    return result;
  }

  Future<bool?> deleteTask(Task task) async {
    if (task.user.tasksCount != 0) {
      task.user.tasksCount--;
    }
    final result = helper.removeTask(task.title.hashCode.toString());
    helper.updateUser(task.user);
    await loadTasks();
    notifyListeners();
    return result;
  }
}
