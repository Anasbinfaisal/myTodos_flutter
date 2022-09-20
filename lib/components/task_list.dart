import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:to_doey/screens/addTask_screen.dart';
import '../services/DatabaseHandler.dart';
import 'task_tile.dart';
import 'package:to_doey/models/task.dart';
import 'package:to_doey/services/task_controller.dart';

late DatabaseHandler handler = DatabaseHandler();
final TaskController _taskController = Get.put(TaskController());
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: handler.retrieveTasks(),
      builder: (context, AsyncSnapshot<List<Task>?> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final task = snapshot.data![index];
              return Task_Tile(
                text: task.name!,
                isChecked: task.isDone == 1 ? true : false,
                checkboxCallback: (state) async {
                  await handler.updateCheckBoxState(
                      task.id!, task.name!, state! ? 1 : 0);

                  setState(() {});
                },
                longPressCallback: () async {
                  await handler.deleteTask(task.id!);
                  await flutterLocalNotificationsPlugin.cancel(task.id!);

                  setState(() {
                    snapshot.data!.remove(snapshot.data![index]);
                  });
                  Fluttertoast.showToast(
                      msg: 'Task Deleted!',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.blueGrey,
                      textColor: Colors.white);
                },
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => AddTaskScreen(
                            id: task.id,
                          ));
                },
              );
            },
            itemCount: snapshot.data?.length,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
