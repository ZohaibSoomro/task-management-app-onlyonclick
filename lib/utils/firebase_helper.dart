import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:task_management_app_onlyonclick/models/task.dart';
import 'package:task_management_app_onlyonclick/models/user.dart';

class FirebaseHelper {
  static final FirebaseHelper instance = FirebaseHelper._();
  final _usersCollection = FirebaseFirestore.instance.collection('users');
  final _tasksCollection = FirebaseFirestore.instance.collection('tasks');

  FirebaseHelper._();

  Future<User?> getUserWithEmail(String email) async {
    try {
      final documentSnapshot = await _usersCollection.doc(email).get();
      if (documentSnapshot.exists) {
        return User.fromJson(documentSnapshot.data() as Map<String, dynamic>);
      } else {
        print('No user found with email: $email');
        return null;
      }
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Future<bool?> saveUser(User user) async {
    try {
      await _usersCollection.doc(user.email).set(user.toJson());
      return true;
    } catch (e) {
      debugPrint('Error saving user data: $e');
      return null;
    }
  }

  Future<List<Task>> getAllTasks() async {
    try {
      final querySnapshot = await _tasksCollection.get();
      return querySnapshot.docs.map((e) => Task.fromJson(e.data())).toList();
    } catch (e) {
      print('Error getting all tasks: $e');
      return [];
    }
  }

  Future<bool?> addTask(Task task) async {
    try {
      await _tasksCollection
          .doc(task.title.hashCode.toString())
          .set(task.toJson());
      return true;
    } catch (e) {
      debugPrint('Error saving task data: $e');
      return null;
    }
  }

  Future<bool?> updateTask(String uid, Task task) async {
    try {
      await _tasksCollection.doc(uid).update(task.toJson());
      return true;
    } catch (e) {
      print("Error updating task: $e");
      return null;
    }
  }

  Future<bool?> updateUser(User user) async {
    try {
      await _usersCollection.doc(user.email).update(user.toJson());
      return true;
    } catch (e) {
      print("Error updating user: $e");
      return null;
    }
  }

  Future<bool?> removeTask(String uid) async {
    try {
      await _tasksCollection.doc(uid).delete();
      return true;
    } catch (e) {
      print("Error deleting task: $e");
      return null;
    }
  }
}
