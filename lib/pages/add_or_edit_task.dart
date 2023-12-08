// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app_onlyonclick/constants.dart';
import 'package:task_management_app_onlyonclick/models/task.dart';
import 'package:task_management_app_onlyonclick/sm/task_provider.dart';
import 'package:task_management_app_onlyonclick/utils/firebase_helper.dart';
import 'package:task_management_app_onlyonclick/widgets/my_alert_dialog.dart';
import 'package:task_management_app_onlyonclick/widgets/rectangular_button.dart';

class AddOrEditTask extends StatefulWidget {
  const AddOrEditTask({Key? key, this.task}) : super(key: key);
  final Task? task;

  @override
  State<AddOrEditTask> createState() => _AddOrEditTaskState();
}

class _AddOrEditTaskState extends State<AddOrEditTask> {
  String title = '';
  String description = '';
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descrController = TextEditingController();
  DateTime? deadline;

  int? taskHashCode;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descrController.dispose();
  }

  clearText() {
    titleController.clear();
    descrController.clear();

    deadline = null;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descrController.text = widget.task!.description;

      title = widget.task!.title;
      description = widget.task!.description;
      deadline = widget.task!.deadline;
      taskHashCode = widget.task!.title.hashCode;
      Future.delayed(const Duration(milliseconds: 10)).then((value) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      progressIndicator: SpinKitDoubleBounce(
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven ? Colors.blue : Colors.white,
            ),
          );
        },
      ),
      isLoading: isLoading,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, size: 30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 30),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          Text(
                            '${widget.task != null ? 'Edit' : 'Add'} Task',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: kPrimaryColor, fontSize: 30),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          TextFormField(
                            controller: titleController,
                            onChanged: (value) {
                              title = value;
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Enter task title";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              prefixIcon: IconTheme(
                                data: IconThemeData(color: kPrimaryColor),
                                child: Icon(Icons.title),
                              ),
                              hintText: 'title',
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: descrController,
                            onChanged: (value) {
                              description = value.trim();
                            },
                            validator: (val) {
                              return null;
                            },
                            decoration: const InputDecoration(
                              prefixIcon: IconTheme(
                                  data: IconThemeData(color: kPrimaryColor),
                                  child: Icon(Icons.description)),
                              hintText: 'description(optional)',
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Deadline',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade700),
                                    ),
                                    if (deadline != null)
                                      Flexible(
                                        child: Text(
                                            Jiffy.parse(deadline.toString())
                                                .yMMMdjm),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  child: RectengularRoundedButton(
                                    buttonName:
                                        deadline == null ? 'select' : 'change',
                                    padding: 0,
                                    fontSize: 16,
                                    onPressed: () async {
                                      final dt = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now()
                                            .add(const Duration(days: 2)),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(
                                            DateTime.now().year, 12, 31),
                                      );
                                      if (dt == null) return;
                                      final tod = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (tod != null) {
                                        deadline = DateTime(dt.year, dt.month,
                                            dt.day, tod.hour, tod.minute);
                                      }
                                      if (mounted) setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          RectengularRoundedButton(
                            buttonName: widget.task != null ? 'Update' : 'Add',
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                if (deadline == null) {
                                  showMyAlertDialog(context, "error!",
                                      "please set a deadline.");
                                  return;
                                }
                                toggleLoading();
                                final user = await FirebaseHelper.instance
                                    .getUserWithEmail(context
                                        .read<TasksProvider>()
                                        .currentUserEmail);
                                final task = Task(
                                    deadline: deadline!,
                                    title: title,
                                    description: description,
                                    user: user!);
                                final taskSaved = widget.task != null
                                    ? await context
                                        .read<TasksProvider>()
                                        .editTask(taskHashCode!, task)
                                    : await context
                                        .read<TasksProvider>()
                                        .saveTask(task);
                                if (taskSaved != null && taskSaved) {
                                  toggleLoading();
                                  await showMyAlertDialog(context, 'Info.',
                                      "Task ${widget.task == null ? 'created' : 'updated'} successfully.",
                                      isError: false);
                                  Navigator.pop(context);
                                } else {
                                  await showMyAlertDialog(context, 'error!',
                                      "Some error occurred.");
                                }
                                if (mounted) {
                                  if (isLoading) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }
}
