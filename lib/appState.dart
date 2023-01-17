import 'package:myapp/taskModel.dart';
import 'package:myapp/taskStatusModel.dart';

class AppState {

  static int _increment_id = 0;

  static List<Task> _tasks = [];

  static void addTask(
      String title,
      String description,
      TaskStatus status){
    _tasks.add(new Task(id: ++_increment_id, title: title, description: description, status: status, updateTime: DateTime.now()));
    sortTasks();
  }

  static void removeTaskById(int id){
    _tasks.removeWhere((element) => element.id == id);
  }

  static void sortTasks(){
    _tasks.sort((Task a, Task b) => b.updateTime.millisecondsSinceEpoch - a.updateTime.millisecondsSinceEpoch);
  }

  static List<Task> getFilteredTasks(TaskStatus? status){
    if (status == null) {
      return _tasks;
    }

    return _tasks.where((element) => element.status == status).toList();
  }
}