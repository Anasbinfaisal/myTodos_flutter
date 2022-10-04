import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:to_doey/components/task_list.dart';
import 'package:to_doey/components/task_tile.dart';

import '../constants.dart';
import '../models/task.dart';
import '../screens/addTask_screen.dart';
import '../services/DatabaseHandler.dart';

late DatabaseHandler handler = DatabaseHandler();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

bool isExpanded = false;

int? count;
ScrollController _scrollController = ScrollController();

class ExpansionList extends StatefulWidget {
  @override
  State<ExpansionList> createState() => _ExpansionListState();
}

class _ExpansionListState extends State<ExpansionList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: handler.retrieveTasks_completed(),
      builder: (context, AsyncSnapshot<List<Task>?> snapshot) {
        if (snapshot.hasData) {
          return ExpansionTile(
              onExpansionChanged: (value) {
                isExpanded = value;
              },
              maintainState: true,
              title: Text("Completed Tasks (${snapshot.data!.length})"),
              children: [
                ListView.builder(
                  controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
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
                        modelSheetWidget(context, task);
                      },
                    );
                  },
                ),
              ]);
        } else {
          return Container(
              // child: const Center(
              //   child: Text(
              //     "No Tasks Added!",
              //     style: TextStyle(fontSize: 25),
              //   ),
              // ),
              );
        }
      },
    );
  }
}
