import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/models/taskModel.dart';
import 'package:myapp/appState.dart';
import 'package:myapp/models/taskStatusModel.dart';
import 'package:myapp/homePage.dart';
import 'package:intl/intl.dart';


class TaskPage extends StatefulWidget {

  Task task;
  TaskStatus newStatus = TaskStatus.Open;

  TaskPage({super.key, required this.task}){
    newStatus = task.status;
  }

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  static const String _title = 'Task Details';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: Text('Alert!'),
                    content: Text('This task will be deleted from your local storage.'),
                    actions: [
                      CupertinoDialogAction(
                        child: Text('Cancel'),
                        isDefaultAction: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text('Delete'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Task '${widget.task.title}' deleted!"),
                            ),
                          );
                          AppState.removeTaskById(widget.task.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainPage()),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Icon(Icons.delete),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: [
            // Task title
            Padding(
              padding: EdgeInsets.only(left: 4.0, top: 5.0, right: 4.0, bottom: 8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(widget.task.title, style: TextStyle(fontSize: 20.0)),
              ),
            ),
            Divider(),
            // Task description
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(5.0),
                // decoration: BoxDecoration(
                //   border: Border.all(color: Colors.grey, width: 2.0, style: BorderStyle.solid),
                //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
                // ),
                child: Text(widget.task.description, style: TextStyle(fontSize: 15.0)),
              ),
            ),
            Divider(),
            // Task status and last updated time
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Status: '),
                    DropdownButton<TaskStatus>(
                      onChanged: (TaskStatus? newValue) {
                        setState(() {
                          widget.newStatus = newValue!;
                        });
                      },
                      value: widget.newStatus,
                      items: TaskStatus.values.map<DropdownMenuItem<TaskStatus>>(
                            (TaskStatus value) {
                          return DropdownMenuItem<TaskStatus>(
                            value: value,
                            child: Text(value.name),
                          );
                        },
                      ).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Last update: '),
                    Text(DateFormat('yyyy-MM-dd  kk:mm').format(widget.task.updateTime).toString()),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                widget.task.status = widget.newStatus;
                widget.task.updateTime = DateTime.now();
                AppState.sortTasks();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Task updated!"),
                  ),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              },
              child: const Text('Update task'),
            ),
          ],
        ),
      ),
    );
  }
}
