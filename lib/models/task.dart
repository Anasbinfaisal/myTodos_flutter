class Task {
  int? id;
  String name;
  int isDone;

  Task({this.id, required this.name, this.isDone = 0});

  void toggleDone() {
    if (isDone == 1)
      isDone = 0;
    else if (isDone == 0) isDone = 1;
  }

  Task.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res["name"],
        isDone = res["isDone"];

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'isDone': isDone};
  }
}
