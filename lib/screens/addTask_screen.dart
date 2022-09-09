import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:to_doey/TaskData.dart';
import 'package:to_doey/components/task_tile.dart';
import 'package:to_doey/models/task.dart';

import '../services/DatabaseHandler.dart';

late DatabaseHandler handler = DatabaseHandler();

class AddTaskScreen extends StatefulWidget {
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  //final Function addTaskCallback;
  String taskText = '';

  late final TextEditingController? controller = TextEditingController();
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  //AddTaskScreen({required this.addTaskCallback});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Add Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontSize: 30,
              ),
            ),
            TextField(
              decoration: const InputDecoration(hintText: "Enter Task"),
              controller: controller,
              onChanged: (value) {
                setState(() {
                  taskText = value;
                });
              },
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      primary: Colors.white,
                      textStyle: const TextStyle(fontSize: 20),
                      fixedSize: Size(200, 50),
                    ),
                    onPressed: () async {
                      if (taskText.isNotEmpty) {
                        await handler.insertTask(Task(name: taskText));
                        controller?.clear();
                        // Provider.of<TaskData>(context, listen: false)
                        //     .addTask(taskText);

                        setState(() {});

                        Fluttertoast.showToast(
                            msg: 'Task Added!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.blueGrey,
                            textColor: Colors.white);

                        Navigator.pop(context);
                      } else {
                        Fluttertoast.showToast(
                            msg: 'No text entered!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.blueGrey,
                            textColor: Colors.white);
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ],
        ),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            )),
      ),
    );
  }
}
