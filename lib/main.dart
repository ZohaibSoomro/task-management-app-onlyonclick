import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management_app_onlyonclick/models/user.dart';
import 'package:task_management_app_onlyonclick/pages/home.dart';
import 'package:task_management_app_onlyonclick/pages/login.dart';
import 'package:task_management_app_onlyonclick/pages/signup.dart';
import 'package:task_management_app_onlyonclick/sm/task_provider.dart';
import 'package:task_management_app_onlyonclick/utils/firebase_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString(Login.email);
  bool loginStatus = prefs.getBool(Login.isLoggedIn) ?? false;
  runApp(TaskManagementApp(
    isLoggedIn: loginStatus,
    email: email,
  ));
}

class TaskManagementApp extends StatelessWidget {
  const TaskManagementApp({Key? key, required this.isLoggedIn, this.email})
      : super(key: key);
  final bool isLoggedIn;
  final String? email;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TasksProvider(),
      child: MaterialApp(
        title: 'Task Management App',
        debugShowCheckedModeBanner: false,
        home: email == null
            ? const Login()
            : FutureBuilder<User?>(
                future: FirebaseHelper.instance.getUserWithEmail(email!),
                builder: (context, snapshot) {
                  if (snapshot.hasData && isLoggedIn) {
                    return Home(user: snapshot.data!);
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
      ),
    );
  }
}
