// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app_onlyonclick/constants.dart';
import 'package:task_management_app_onlyonclick/models/task.dart';
import 'package:task_management_app_onlyonclick/models/user.dart';
import 'package:task_management_app_onlyonclick/pages/add_or_edit_task.dart';
import 'package:task_management_app_onlyonclick/sm/task_provider.dart';
import 'package:task_management_app_onlyonclick/widgets/my_alert_dialog.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: kPrimaryColor,
        textColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (context.read<TasksProvider>().currentUserRole ==
                        UserType.admin &&
                    context.read<TasksProvider>().currentUserEmail !=
                        task.user.email)
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text(
                      'by ${task.user.name}',
                      style: TextStyle(fontSize: 12),
                    ),
                  )
              ],
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
            Column(
              children: [
                Text(
                  '${task.isCompleted ? '' : 'mark'} completed',
                  style: const TextStyle(fontSize: 14),
                ),
                Checkbox(
                  activeColor: Colors.white,
                  checkColor: kPrimaryColor,
                  fillColor: MaterialStateProperty.resolveWith(
                      (states) => kSecondaryColor),
                  value: task.isCompleted,
                  onChanged: (val) {
                    if (val == null) return;
                    if (val) {
                      task.isCompleted = val;
                      context
                          .read<TasksProvider>()
                          .editTask(task.title.hashCode, task);
                      showMyAlertDialog(
                          context, "Info.", "task marked as completed.",
                          isError: false);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  task.description.isEmpty
                      ? 'description not added.'
                      : task.description,
                  style: TextStyle(
                    color: task.description.isNotEmpty
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: task.isCompleted
                          ? null
                          : () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddOrEditTask(task: task),
                              ));
                            },
                      child: Chip(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        backgroundColor: !task.isCompleted
                            ? kPrimaryColor
                            : kPrimaryColor.withOpacity(0.5),
                        label: Icon(Icons.edit,
                            color: task.isCompleted
                                ? Colors.white54
                                : Colors.white),
                      ),
                    ),
                    if (context.read<TasksProvider>().currentUserRole ==
                        UserType.admin)
                      InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          context
                              .read<TasksProvider>()
                              .deleteTask(task)
                              .then((value) {
                            if (value != null && value) print("Task deleted.");
                          });
                        },
                        child: Chip(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          backgroundColor: !task.isCompleted
                              ? kPrimaryColor
                              : kPrimaryColor.withOpacity(0.5),
                          label: const Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            task.deadline.isAfter(DateTime.now())
                ? Text(
                    "deadline: ${Jiffy.parse(task.deadline.toString()).yMMMEdjm}${task.isCompleted ? '' : '(${Jiffy.now().to(Jiffy.parse(task.deadline.toString()))})'}")
                : Text(
                    "deadline: ${Jiffy.parse(task.deadline.toString()).yMMMEdjm}${task.isCompleted ? '' : '(${Jiffy.parse(task.deadline.toString()).fromNow()})'}",
                    style: TextStyle(
                        color: task.isCompleted ? Colors.white : Colors.red),
                  ),
          ],
        ),
      ),
    );
  }
}
