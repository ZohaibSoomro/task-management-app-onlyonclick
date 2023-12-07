import 'package:task_management_app_onlyonclick/models/task.dart';
import 'package:task_management_app_onlyonclick/models/user.dart';

class FirebaseHelper {
  static final FirebaseHelper instance = FirebaseHelper._();

  FirebaseHelper._();

  Future<User?> getUserWithEmail(String email) async {
    return User(
        type: UserType.user, name: "zhs", email: email, password: "123456");
  }

  Future<bool?> saveUser(User user) async {
    return true;
  }

  Future<List<Task>> loadTasks() {
    throw Exception();
  }
}
