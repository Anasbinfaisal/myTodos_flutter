import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:to_doey/models/task.dart';

class DatabaseHandler {
  static Database? _database;
  static const String _tableName = 'tasks';

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, '$_tableName.db'),
      onCreate: (database, version) async {
        await database.execute("CREATE TABLE $_tableName ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "name TEXT NOT NULL, title TEXT NOT NULL, "
            "date STRING, startTime STRING, "
            "remind INTEGER, repeat STRING, "
            "isDone INTEGER)");
      },
      version: 1,
    );
  }

  //IF NOT EXISTS
  Future<int?> getCount() async {
    final Database db = await initializeDB();
    int? count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $_tableName'));
    return count;
  }

  static Future<List<Map<String, dynamic>>> query() async {

    var list = await _database!.query(_tableName);

    return list;
  }

  Future<Task> getTask(int id) async {
    final Database db = await initializeDB();
    final data = await db.query(
      _tableName,
      where: 'id=?',
      whereArgs: [id],
    );
    return Task.fromMap(data.first);
  }

  static Future updateTaskStatus(int id) async {
    return await _database!.rawUpdate('''
   UPDATE tasks
   SET isCompleted = ?
   WHERE id =? 
    ''', [1, id]);
  }

  Future<int> updateTask(Task? task) async {
    final Database db = await initializeDB();
    final data = await db.update(
      _tableName,
      task!.toMap(),
      where: 'id=?',
      whereArgs: [task.id],
    );
    return data;
  }

  Future<int> updateCheckBoxState(int id, String name, int state) async {
    final Database db = await initializeDB();

    final data = {'id': id, 'name': name, 'isDone': state};

    final result =
        await db.update(_tableName, data, where: "id = ?", whereArgs: [id]);
    return result;
  }


  Future<List<Task>> retrieveTasks_completed() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query(_tableName, where: "isDone = 1");
    return queryResult.map((e) => Task.fromMap(e)).toList();
  }

  Future<List<Task>> retrieveTasks_notcompleted() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query(_tableName, where: "isDone = 0");
    return queryResult.map((e) => Task.fromMap(e)).toList();
  }

  Future<int> insertTask(Task task) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.insert('tasks', task.toMap());
    return result;
  }

  Future<void> deleteTask(int id) async {
    final db = await initializeDB();
    await db.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }


}
