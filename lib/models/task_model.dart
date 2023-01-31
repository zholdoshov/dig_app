import 'package:myapp/models/task_status_model.dart';
import 'package:myapp/models/task_relation_model.dart';
import 'package:tuple/tuple.dart';

class Task {
  int id;
  String title;
  String description;
  TaskStatus status;
  DateTime updateTime;
  Set<Tuple2<TaskRelation, Task>> relatedTasks = {};

  Task(
      {required this.id,
      required this.title,
      required this.description,
      required this.status,
      required this.updateTime});
}
