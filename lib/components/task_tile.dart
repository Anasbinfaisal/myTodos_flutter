import 'package:flutter/material.dart';

class Task_Tile extends StatelessWidget {
  Task_Tile(
      {required this.text,
      required this.isChecked,
      required this.checkboxCallback,
      required this.longPressCallback});

  late String text;
  late bool isChecked;
  late Function(bool?) checkboxCallback;
  late Function()? longPressCallback;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: longPressCallback,
      title: Text(
        text,
        style: TextStyle(
          decoration: isChecked ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Checkbox(
        activeColor: Colors.lightBlueAccent,
        value: isChecked,
        onChanged: checkboxCallback,
      ),
    );
  }
}
