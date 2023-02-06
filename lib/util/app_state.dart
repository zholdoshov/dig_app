// ignore_for_file: non_constant_identifier_names

import 'package:myapp/models/task_model.dart';
import 'package:myapp/models/task_status_model.dart';
import 'package:myapp/models/task_relation_model.dart';

class AppState {
  static final List<Task> _tasks = [
    // Task(
    //     id: 0,
    //     title: 'Default Task',
    //     description: 'This is a built-in task',
    //     status: TaskStatus.Open,
    //     updateTime: DateTime.now()),
  ];

  static final Map<TaskRelation, Task> _relatedIssues = {};

  static int _increment_id = 1;

  static void addTask(String title, String description, TaskStatus status) {
    _tasks.add(Task(
        id: ++_increment_id,
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
