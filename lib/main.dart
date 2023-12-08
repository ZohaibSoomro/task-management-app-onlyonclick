import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management_app_onlyonclick/models/user.dart';
import 'package:task_management_app_onlyonclick/pages/home.dart';
import 'package:task_management_app_onlyonclick/pages/login.dart';
import 'package:task_management_app_onlyonclick/pages/signup.dart';
import 'package:task_management_app_onlyonclick/sm/task_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString(Login.email);
  String? role = prefs.getString(Login.role);
  print("Loaded email: $email");
  bool loginStatus = prefs.getBool(Login.isLoggedIn) ?? false;
  runApp(TaskManagementApp(
    isLoggedIn: loginStatus,
    email: email,
    userRole: role,
  ));
}

class TaskManagementApp extends StatelessWidget {
  const TaskManagementApp(
      {Key? key, required this.isLoggedIn, this.email, this.userRole})
      : super(key: key);
  final bool isLoggedIn;
  final String? email;
  final String? userRole;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TasksProvider(),
      builder: (context, v) {
        return MaterialApp(
          title: 'Task Management App',
          debugShowCheckedModeBanner: false,
          home: email == null
              ? const Login()
              : FutureBuilder<bool?>(
                  future: getUser(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && isLoggedIn) {
                      return Home(userEmail: email!);
                    }
                    if (snapshot.hasError) {
                      return const Login();
                    }
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }),
          routes: {
            Login.id: (context) => const Login(),
            SignUp.id: (context) => const SignUp(),
          },
        );
      },
    );
  }

  Future<bool> getUser(BuildContext context) async {
    Future.delayed(const Duration(milliseconds: 5)).then((value) {
      context.read<TasksProvider>().setCurrentUser(email!);
      context.read<TasksProvider>().setCurrentUserRole(
          UserType.values.where((role) => role.name == userRole).first);
    });

    return true;
  }
}
