import 'package:flutter/material.dart';
import 'package:to_doey/constants.dart';
import '../components/task_list.dart';
import '../services/DatabaseHandler.dart';
import 'addTask_screen.dart';
import 'package:to_doey/components/task_tile.dart';
import 'package:to_doey/models/task.dart';
import 'package:provider/provider.dart';
import 'package:to_doey/TaskData.dart';

class TasksScreen extends StatefulWidget {
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late String newTaskText;
  late DatabaseHandler handler;
  int? count = 0;

  @override
  Widget build(BuildContext context) {
    handler = DatabaseHandler();
    handler.getCount().then((value) {
      setState(() {
        count = value; // Future is completed with a value.
      });
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context, builder: (context) => AddTaskScreen());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.red,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 60, left: 30, right: 30, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  child: Icon(
                    Icons.list,
                    size: 30,
                    color: Colors.red,
                  ),
                  backgroundColor: Colors.white,
                  radius: 30,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'MyTodos',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 50),
                ),
                Text(
                  ' $count Tasks',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TaskList(),
            ),
          ))
        ],
      ),
    );
  }
}
