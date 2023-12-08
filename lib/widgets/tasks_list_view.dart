import 'package:flutter/material.dart';
import 'package:task_management_app_onlyonclick/models/task.dart';
import 'package:task_management_app_onlyonclick/widgets/task_tile.dart';

class TasksListView extends StatefulWidget {
  const TasksListView({Key? key, required this.tasks}) : super(key: key);
  final List<Task> tasks;

  @override
  State<TasksListView> createState() => _TasksListViewState();
}

class _TasksListViewState extends State<TasksListView> {
  @override
  Widget build(BuildContext context) {
    return widget.tasks.isEmpty
        ? const Center(
            child: Text('No tasks available.'),
          )
        : ListView(
            children: widget.tasks
                .map(
                  (t) => TaskTile(task: t),
                )
                .toList(),
          );
  }
}
