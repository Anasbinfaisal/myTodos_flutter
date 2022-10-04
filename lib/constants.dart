import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_doey/screens/addTask_screen.dart';
import 'models/task.dart';

const klist_textstyle = TextStyle(fontSize: 20);

void modelSheetWidget(BuildContext context, Task task) {
  showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      context: context,
      builder: (context) => AddTaskScreen(
            id: task.id,
          ));
}
