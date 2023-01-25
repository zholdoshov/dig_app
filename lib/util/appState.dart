import 'package:myapp/models/taskModel.dart';
import 'package:myapp/models/taskStatusModel.dart';
import 'package:myapp/models/taskRelationModel.dart';
import 'package:tuple/tuple.dart';
import 'package:provider/provider.dart';

class AppState {

  static List<Task> _tasks = [
    Task(id: 0, title: 'Default Task', description: 'This is a built-in task', status: TaskStatus.Open, updateTime: DateTime.now()),
  ];

  static Map<TaskRelation, Task> _relatedIssues = new Map();

  static int _increment_id = 1;

  static void addTask(
      String title,
      String description,
      TaskStatus status){
    _tasks.add(new Task(id: ++_increment_id, title: title, description: description, status: status, updateTime: DateTime.now()));
    sortTasks();
  }

  static void addRelatedIssue(TaskRelation relation, Task task) {
    _relatedIssues.addAll({relation: task});
  }

  static void removeTaskById(int id){
    _tasks.removeWhere((element) => element.id == id);
  }

  static void sortTasks(){
    _tasks.sort((Task a, Task b) => b.updateTime.millisecondsSinceEpoch - a.updateTime.millisecondsSinceEpoch);
  }

  static Task getFirstTask() {
    return _tasks.elementAt(0);
  }

  static Map<TaskRelation, Task> getRelatedTasksMap() {
    return _relatedIssues;
  }

  static List<Task> getFilteredTasks(TaskStatus? status){
    if (status == null) {
      return _tasks;
    }

    return _tasks.where((element) => element.status == status).toList();
  }
}