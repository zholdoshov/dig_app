import 'package:myapp/models/taskStatusModel.dart';
import 'package:myapp/models/taskRelationModel.dart';
import 'package:tuple/tuple.dart';

class Task {
  int id;
  String title;
  String description;
  TaskStatus status;
  DateTime updateTime;
  Set<Tuple2<TaskRelation, Task>> relatedTasks = new Set();

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.updateTime
  });
}

