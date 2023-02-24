import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TaskProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _listTask = [];

  UnmodifiableListView<Map<String, dynamic>> get tasks =>
      UnmodifiableListView(_listTask);

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
    notifyListeners();
  }
}
