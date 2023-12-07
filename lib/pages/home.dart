// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management_app_onlyonclick/constants.dart';
import 'package:task_management_app_onlyonclick/models/task.dart';
import 'package:task_management_app_onlyonclick/models/user.dart';
import 'package:task_management_app_onlyonclick/pages/login.dart';
import 'package:task_management_app_onlyonclick/sm/task_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: context.read<TasksProvider>().loadTasks(),
      builder: (context, snapshot) {
        return LoadingOverlay(
          isLoading: snapshot.connectionState != ConnectionState.done,
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: kPrimaryColor,
                title: Text('Welcome ${widget.user.name}!'),
                actions: [
                  IconButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove(Login.email);
                      await prefs.setBool(Login.isLoggedIn, false);
                      Navigator.pushReplacementNamed(context, Login.id);
                    },
                    icon: const Icon(Icons.logout),
                  )
                ],
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'pending'),
                    Tab(text: 'completed'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  ListView(
                    children: context
                        .read<TasksProvider>()
                        .tasks
                        .where((task) => !task.isCompleted)
                        .map((t) => ListTile(
                              title: Text(t.title),
                            ))
                        .toList(),
                  ),
                  ListView(
                    children: context
                        .read<TasksProvider>()
                        .tasks
                        .where((task) => task.isCompleted)
                        .map((t) => ListTile(
                              title: Text(t.title),
                            ))
                        .toList(),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                backgroundColor: kPrimaryColor,
                child: Icon(Icons.add),
              ),
            ),
          ),
        );
      },
    );
  }
}
