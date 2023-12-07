import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app_onlyonclick/pages/login.dart';
import 'package:task_management_app_onlyonclick/pages/signup.dart';
import 'package:task_management_app_onlyonclick/sm/task_provider.dart';

void main() {
  runApp(const TaskManagementApp());
}

class TaskManagementApp extends StatelessWidget {
  const TaskManagementApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TasksProvider()..loadTasks(),
      child: MaterialApp(
        title: 'Task Management App',
        debugShowCheckedModeBanner: false,
        home: const Login(),
        routes: {
          Login.id: (context) => const Login(),
          SignUp.id: (context) => const SignUp(),
        },
      ),
    );
  }
}
