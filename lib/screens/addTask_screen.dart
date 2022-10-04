import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:to_doey/models/task.dart';
import 'package:to_doey/components/input_field.dart';
import '../app_themes.dart';
import '../services/DatabaseHandler.dart';
import '../services/notification_helper.dart';
import '../services/task_controller.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key, this.id}) : super(key: key);
  final int? id;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late DatabaseHandler handler = DatabaseHandler();
  GlobalKey<FormState> formKey = GlobalKey();

  TaskController _taskController = Get.put(TaskController());
  TextEditingController titleController = TextEditingController();

  FocusNode taskBodyNode = FocusNode();
  TextEditingController taskBodyController = TextEditingController();

  FocusNode taskTitleNode = FocusNode();
  TextEditingController taskTitleController = TextEditingController();

  FocusNode dateNode = FocusNode();
  TextEditingController dateController = TextEditingController();

  FocusNode startTimeNode = FocusNode();
  TextEditingController startTimeController = TextEditingController();

  FocusNode remindNode = FocusNode();
  TextEditingController remindController = TextEditingController();

  FocusNode repeatNode = FocusNode();
  TextEditingController repeatController = TextEditingController();

  DateTime date = DateTime.now();

  final String _currentTime = DateFormat('hh:mm a').format(DateTime.now());

  int _defaultValue = 0;

  String _repeatMode = 'Never';

  List<dynamic> remindList = ['Never', 5, 10, 15, 20];
  List<String> repeatList = ['Never', 'Day', 'Week', 'Month'];

  Task? task;
  String taskText = '';
  var notifyHelper;

  TextEditingController? controller = TextEditingController();

  @override
  void initState() {
    notifyHelper = NotificationHelper();
    notifyHelper.initNotification();

    dateController.text = DateFormat.yMd().format(date);
    startTimeController.text = _currentTime;
    repeatController.text = _repeatMode;
    remindController.text = 'Never';

    widget.id != null ? getTask() : super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    taskBodyController.clear();
    taskTitleController.clear();
    dateController.clear();
    startTimeController.clear();
    remindController.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenH = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xff757575),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InputField(
                      textValueController: taskTitleController,
                      node: taskTitleNode,
                      label: 'Title',
                      hint: 'Add Task Title',
                      suffixIcon: const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
                      onValidate: (value) {},
                    ),
                    InputField(
                      textValueController: taskBodyController,
                      node: taskBodyNode,
                      maxLine: 5,
                      label: 'Content',
                      hint: 'Add Task Content',
                      suffixIcon: const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
                      onValidate: (value) {},
                    ),
                    SizedBox(
                      height: screenH * 0.05,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InputField(
                            textValueController: dateController,
                            node: dateNode,
                            label: 'Date',
                            hint: '$dateController',
                            suffixIcon: const Icon(
                              FontAwesomeIcons.calendar,
                              color: Colors.green,
                            ),
                            onSuffixTap: () {
                              _getDate();
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          child: InputField(
                            textValueController: startTimeController,
                            node: startTimeNode,
                            label: 'Start time',
                            hint: _currentTime,
                            suffixIcon: const Icon(
                              Icons.watch_later_outlined,
                              color: Colors.green,
                            ),
                            onSuffixTap: () {
                              _getTime();
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InputField(
                            textValueController: remindController,
                            node: remindNode,
                            label: 'Remind me ',
                            hint: '$remindController',
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: _showReminderMinutesList(),
                            ),
                            onSuffixTap: () {},
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          child: InputField(
                            textValueController: repeatController,
                            node: repeatNode,
                            label: 'Repeat every ',
                            hint: '$repeatController',
                            onValidate: (value) {},
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: _showRepeatList(),
                            ),
                            onSuffixTap: () {},
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenH * 0.05,
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
                              fixedSize: const Size(200, 60),
                            ),
                            onPressed: () async {
                              if (taskBodyController.text.isNotEmpty &&
                                  taskTitleController.text.isNotEmpty) {
                                _submit();
                                setState(() {});

                                if (widget.id == null) {
                                  Fluttertoast.showToast(
                                      msg: 'Task Added!',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.blueGrey,
                                      textColor: Colors.white);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Task Updated!',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.blueGrey,
                                      textColor: Colors.white);
                                }
                                Navigator.pop(context);
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Please fill all text boxes!',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.blueGrey,
                                    textColor: Colors.white);
                              }
                            },
                            child: widget.id == null
                                ? const Text('Add')
                                : const Text('Update'),
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
            ),
          ],
        ),
      ),
    );
  }

  _submit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      widget.id == null ? _uploadTask() : _updateTask();
    }
  }

  _uploadTask() async {
    print(_defaultValue);

    Task task = Task(
        name: taskBodyController.text,
        title: taskTitleController.text,
        date: dateController.text,
        startTime: startTimeController.text,
        remind: _defaultValue,
        repeat: repeatController.text,
        isDone: 0);

    int value1 = await _taskController.addTask(task: task);
    task.id = value1;
    print("task id: ${task.id}");

    // Task task1 = await handler.getTask(value1);

    setNotifications(task);

    print('upload done - Task id: $value1');
  }

  _updateTask() async {
    print('id ::: ${widget.id}');

    Task task = Task(
      id: widget.id,
      name: taskBodyController.text,
      title: taskTitleController.text,
      date: dateController.text,
      startTime: startTimeController.text,
      remind: _defaultValue,
      repeat: repeatController.text,
      //todo: set value
      isDone: 0,
    );

    int value = await _taskController.updateTask(task: task);

    setNotifications(task);

    return value;
  }

  getTask() async {
    task = await handler.getTask(widget.id!.toInt());
    setState(() {
      taskBodyController.text = task!.name.toString();
      taskTitleController.text = task!.title.toString();
      dateController.text = task!.date.toString();
      startTimeController.text = task!.startTime.toString();

      if (task!.remind.toString() == '0') {
        remindController.text = 'Never';
      } else {
        remindController.text = '${task!.remind.toString()} Minutes';
      }
      _defaultValue = task!.remind!;
      _repeatMode = task!.repeat.toString();

      repeatController.text = task!.repeat.toString();
    });
  }

  _getDate() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (_pickerDate != null) {
      setState(() {
        date = _pickerDate;
        dateController.text = DateFormat.yMd().format(date);
      });
    }
  }

  _getTime() async {
    var selectedTime = await _showTimePicker();
    String timeFormat = await selectedTime.format(context);
    if (timeFormat.isEmpty) {
      print('error');
    } else {
      setState(() {
        startTimeController.text = timeFormat;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime: TimeOfDay
          //(
          // hour: int.parse(_currentTime.split(':')[0]),
          // minute: int.parse(_currentTime.split(':')[0].split(' ')[0]),
          //   )
          .now(),
    );
  }

  _showReminderMinutesList() {
    return DropdownButton(
      borderRadius: BorderRadius.circular(10),
      icon: const Icon(
        Icons.keyboard_arrow_down,
        size: 18,
      ),
      style: AppThemes().subtitleStyle,
      underline: Container(),
      onChanged: (String? value) {
        value == 'Never'
            ? _defaultValue = 0
            : _defaultValue = int.parse(value!);
        print("Repeat Mode Value: $value");

        setState(() {
          if (value == 'Never') {
            remindController.text = 'Never';
          } else {
            remindController.text = "$_defaultValue Minutes";
          }
        });
      },
      items: remindList.map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem<String>(
          value: value.toString(),
          child: value == _defaultValue
              ? Text(
                  value.toString(),
                  style: const TextStyle(color: Colors.black),
                )
              : Text(value.toString()),
        );
      }).toList(),
    );
  }

  _showRepeatList() {
    return DropdownButton(
      borderRadius: BorderRadius.circular(10),
      icon: const Icon(
        Icons.keyboard_arrow_down,
        size: 18,
      ),
      style: AppThemes().subtitleStyle,
      underline: Container(),
      onChanged: (String? value) {
        _repeatMode = value!;
        setState(() {
          repeatController.text = _repeatMode;
        });
      },
      items: repeatList.map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: value == _repeatMode
              ? Text(
                  value,
                  style: const TextStyle(color: Colors.black),
                )
              : Text(value),
        );
      }).toList(),
    );
  }

  void setNotifications(Task task) {
    print('Selected Time is: ${task.startTime}');

    DateTime time = DateFormat.jm().parse(task.startTime.toString());
    var myTime = DateFormat("HH:mm").format(time);

    if (task.repeat == 'Day' ||
        task.repeat == 'Week' ||
        task.repeat == 'Month' ||
        task.repeat == 'Never') {
      if (task.remind == 0) {
        notifyHelper.scheduledNotification(
          hour: int.parse(myTime.toString().split(":")[0]),
          minute: int.parse(myTime.toString().split(":")[1]),
          task: task,
        );
      } else if (task.remind == 5) {
        notifyHelper.scheduledNotification(
          hour: int.parse(myTime.toString().split(":")[0]),
          minute: int.parse(myTime.toString().split(":")[1]) - 5,
          task: task,
        );
      } else if (task.remind == 10) {
        notifyHelper.scheduledNotification(
          hour: int.parse(myTime.toString().split(":")[0]),
          minute: int.parse(myTime.toString().split(":")[1]) - 10,
          task: task,
        );
      } else if (task.remind == 15) {
        notifyHelper.scheduledNotification(
          hour: int.parse(myTime.toString().split(":")[0]),
          minute: int.parse(myTime.toString().split(":")[1]) - 15,
          task: task,
        );
      } else {
        notifyHelper.scheduledNotification(
          hour: int.parse(myTime.toString().split(":")[0]),
          minute: int.parse(myTime.toString().split(":")[1]) - 20,
          task: task,
        );
      }
      // return Container(
      //   decoration: const BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      //   ),
      // );
      // } else if (task?.date == DateFormat.yMd().format(_selectedDate)) {
      //   if (task?.remind == 5) {
      //     notifyHelper.scheduledNotification(
      //       hour: int.parse(myTime.toString().split(":")[0]),
      //       minute: int.parse(myTime.toString().split(":")[1]) - 5,
      //       task: task,
      //     );
      //   } else if (task?.remind == 10) {
      //     notifyHelper.scheduledNotification(
      //       hour: int.parse(myTime.toString().split(":")[0]),
      //       minute: int.parse(myTime.toString().split(":")[1]) - 10,
      //       task: task,
      //     );
      //   } else if (task?.remind == 15) {
      //     notifyHelper.scheduledNotification(
      //       hour: int.parse(myTime.toString().split(":")[0]),
      //       minute: int.parse(myTime.toString().split(":")[1]) - 15,
      //       task: task,
      //     );
      //   } else {
      //     notifyHelper.scheduledNotification(
      //       hour: int.parse(myTime.toString().split(":")[0]),
      //       minute: int.parse(myTime.toString().split(":")[1]) - 20,
      //       task: task,
      //     );
      //   }
      // } else if (task?.repeat == 'Never' &&
      //     task?.date == DateFormat.yMd().format(_selectedDate)) {
      //   if (task?.remind == 5) {
      //     notifyHelper.scheduledNotification(
      //       hour: int.parse(myTime.toString().split(":")[0]),
      //       minute: int.parse(myTime.toString().split(":")[1]) - 5,
      //       task: task,
      //     );
      //   } else if (task?.remind == 10) {
      //     notifyHelper.scheduledNotification(
      //       hour: int.parse(myTime.toString().split(":")[0]),
      //       minute: int.parse(myTime.toString().split(":")[1]) - 10,
      //       task: task,
      //     );
      //   } else if (task?.remind == 15) {
      //     notifyHelper.scheduledNotification(
      //       hour: int.parse(myTime.toString().split(":")[0]),
      //       minute: int.parse(myTime.toString().split(":")[1]) - 15,
      //       task: task,
      //     );
      //   } else {
      //     notifyHelper.scheduledNotification(
      //       hour: int.parse(myTime.toString().split(":")[0]),
      //       minute: int.parse(myTime.toString().split(":")[1]) - 20,
      //       task: task,
      //     );
      //   }
    }
  }
}
