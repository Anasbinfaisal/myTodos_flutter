import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_doey/screens/addTask_screen.dart';
import 'models/task.dart';
import 'package:intl/intl.dart';

const klist_textstyle = TextStyle(fontSize: 20);
const kempty_date = 'Not Selected';

void modelSheetWidget(BuildContext context, Task task) {
  showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      context: context,
      builder: (context) => AddTaskScreen(
            id: task.id,
          ));
}
