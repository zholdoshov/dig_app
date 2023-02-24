import 'package:myapp/models/task.dart';
import 'package:myapp/models/task_status.dart';
import 'package:myapp/models/task_relation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DatabaseHelper {
  static final List<Task> _tasks = [];

  List<Map<String, dynamic>> _listTask = [];

  List<Map<String, dynamic>> getListTask() {
    return _listTask.toList();
  }

  final _taskBox = Hive.box('task_box');

  void refreshItems() {
    final data = _taskBox.keys.map((key) {
      final item = _taskBox.get(key);
      return {
        "key": key,
        "title": item["title"],
        "description": item["description"],
        "status": item["status"],
        "lastUpdate": item["lastUpdate"]
      };
    }).toList();
    _listTask = data.reversed.toList();
    print(_listTask.length);
  }

  Future<void> createTask(Map<String, dynamic> newTask) async {
    await _taskBox.add(newTask);
    refreshItems();
  }

  static final Map<TaskRelation, Task> _relatedIssues = {};

  static int _incrementId = 1;

  static void addTask(String title, String description, TaskStatus status) {
    _tasks.add(Task(
        id: ++_incrementId,
        title: title,
        description: description,
        status: status,
        updateTime: DateTime.now()));
    sortTasks();
  }

  static void addRelatedIssue(TaskRelation relation, Task task) {
    _relatedIssues.addAll({relation: task});
  }

  static void removeTaskById(int id) {
    _tasks.removeWhere((element) => element.id == id);
  }

  static void sortTasks() {
    _tasks.sort((Task a, Task b) =>
        b.updateTime.millisecondsSinceEpoch -
        a.updateTime.millisecondsSinceEpoch);
  }

  static List<Task> getAllTasks() {
    return _tasks;
  }

  static Task getFirstTask() {
    return _tasks.elementAt(0);
  }

  static Map<TaskRelation, Task> getRelatedTasksMap() {
    return _relatedIssues;
  }

  static List<Task> getFilteredTasks(TaskStatus? status) {
    if (status == null) {
      return _tasks;
    }

    return _tasks.where((element) => element.status == status).toList();
  }
}
