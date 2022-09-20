import 'package:to_doey/models/task.dart';

import 'DatabaseHandler.dart';

class TaskController {
  DatabaseHandler handler = DatabaseHandler();

  Future<int> addTask({required Task task}) async {
    return await handler.insertTask(task);
  }

  Future<int> updateTask({Task? task}) async {
    return await handler.updateTask(task);
  }
}
