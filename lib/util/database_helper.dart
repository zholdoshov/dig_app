import 'dart:io';

import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/models/task_status.dart';
import 'package:myapp/models/task_relation.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT,
        status TEXT,
        updateTime TEXT
      )
    ''');
  }

  Future<List<Task>> getTasks() async {
    Database db = await instance.database;
    var tasks = await db.query('tasks', orderBy: 'updateTime');
    List<Task> taskList =
        tasks.isEmpty ? tasks.map((e) => Task.fromMap(e)).toList() : [];
    return taskList;
  }

  static final List<Task> _tasks = [];

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
