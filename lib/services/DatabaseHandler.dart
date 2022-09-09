import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:to_doey/models/task.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'tasks.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE IF NOT EXISTS tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, isDone INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<int?> getCount() async {
    final Database db = await initializeDB();
    int? count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM tasks'));
    return count;
  }

  Future<int> updateCheckBoxState(int id, String name, int state) async {
    final Database db = await initializeDB();

    final data = {'id': id, 'name': name, 'isDone': state};

    final result =
        await db.update('tasks', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  Future<int> insertTasks(List<Task> tasks) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var task in tasks) {
      result = await db.insert('tasks', task.toMap());
    }
    return result;
  }

  Future<int> insertTask(Task task) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.insert('tasks', task.toMap());
    return result;
  }

  Future<List<Task>> retrieveTasks() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('tasks');
    return queryResult.map((e) => Task.fromMap(e)).toList();
  }

  Future<void> deleteTask(int id) async {
    final db = await initializeDB();
    await db.delete(
      'tasks',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
