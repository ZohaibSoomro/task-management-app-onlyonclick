// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management_app_onlyonclick/constants.dart';
import 'package:task_management_app_onlyonclick/models/user.dart';
import 'package:task_management_app_onlyonclick/pages/add_or_edit_task.dart';
import 'package:task_management_app_onlyonclick/pages/login.dart';
import 'package:task_management_app_onlyonclick/sm/task_provider.dart';
import 'package:task_management_app_onlyonclick/utils/firebase_helper.dart';
import 'package:task_management_app_onlyonclick/widgets/tasks_list_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.userEmail}) : super(key: key);
  final String userEmail;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoadingTasks = false;
  User? user;

  @override
  void initState() {
    super.initState();
    setUser().then((value) => setTasks());
  }

  Future setUser() async {
    user = await FirebaseHelper.instance.getUserWithEmail(widget.userEmail);
    if (mounted) {
      setState(() {});
    }
  }

  setTasks() async {
    setState(() {
      isLoadingTasks = true;
    });
    await context.read<TasksProvider>().loadTasks();
    setState(() {
      isLoadingTasks = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoadingTasks,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome ${user?.name}!'),
                  SizedBox(height: 5),
                  Text('(${user?.type.name})', style: TextStyle(fontSize: 15))
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: setTasks,
                icon: const Icon(Icons.refresh),
              ),
              const SizedBox(width: 5),
              IconButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove(Login.email);
                  await prefs.setBool(Login.isLoggedIn, false);
                  Navigator.pushReplacementNamed(context, Login.id);
                },
                icon: const Icon(Icons.logout),
              ),
            ],
            bottom: const TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: 'pending'),
                Tab(text: 'completed'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              buildPendingTasksListView(),
              buildCompletedTasksListView(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddOrEditTask()),
              ).then((value) => setState(() {}));
            },
            backgroundColor: kPrimaryColor,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Widget buildCompletedTasksListView() {
    return TasksListView(
      tasks: context
          .watch<TasksProvider>()
          .tasks
          .where((task) => task.isCompleted)
          .toList(),
    );
  }

  Widget buildPendingTasksListView() {
    return TasksListView(
      tasks: context
          .watch<TasksProvider>()
          .tasks
          .where((task) => !task.isCompleted)
          .toList(),
    );
  }
}
