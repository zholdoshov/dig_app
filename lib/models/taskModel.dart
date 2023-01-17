import 'package:myapp/taskStatusModel.dart';

class Task{
  int id;
  String title;
  String description;
  TaskStatus status;
  DateTime updateTime;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.updateTime
  });
}

