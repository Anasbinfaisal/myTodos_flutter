class Task {
  int? id;
  String? name;
  String? title;
  int? isDone;
  int? remind;
  String? date;
  String? startTime;
  String? repeat;

  Task(
      {this.id,
      this.name,
      this.title,
      this.isDone,
      this.date,
      this.remind,
      this.repeat,
      this.startTime});

  // void toggleDone() {
  //   if (isDone == 1)
  //     isDone = 0;
  //   else if (isDone == 0) isDone = 1;
  // }

  Task.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res["name"],
        title = res["title"],
        date = res["date"],
        startTime = res["startTime"],
        remind = res["remind"],
        repeat = res["repeat"],
        isDone = res["isDone"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'date': date,
      'startTime': startTime,
      'remind': remind,
      'repeat': repeat,
      'isDone': isDone
    };
  }
}
