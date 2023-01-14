import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:myapp/taskModel.dart';
import 'package:myapp/homepage.dart';

class TaskPage extends StatelessWidget {
  final int index;
  static const String _title = 'Task';

  static final int _TASK_TITLE = 0;
  static final int _TASK_DESCRIPTION = 1;
  static final int _TASK_STATUS = 2;
  static final int _TASK_LAST_UPDATED = 3;

  final taskDB = Hive.box('taskDB');

  TaskPage({required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        // backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(getData(_TASK_TITLE), style: textStyle(20.0)),
            Text(getData(_TASK_DESCRIPTION), style: textStyle(15.0)),
            Text(getData(_TASK_STATUS), style: textStyle(15.0)),
            Text(getData(_TASK_LAST_UPDATED), style: textStyle(15.0)),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Task '${taskDB.getAt(index)[0].toString()}' deleted!"),
                  ),
                );
                taskDB.deleteAt(index);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              },
              child: const Text('Delete task!'),
            ),
          ],
        ),
      ),
    );
  }

  getData(value) {
    return taskDB.getAt(index)[value].toString();
  }

  textStyle(size) {
    return TextStyle(fontSize: size, fontWeight: FontWeight.bold);
  }
}
