import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/screens/appBarTitle.dart';
import 'package:myapp/models/taskModel.dart';
import 'package:myapp/models/taskRelationModel.dart';
import 'package:myapp/util/appState.dart';
import 'package:myapp/models/taskStatusModel.dart';
import 'package:myapp/screens/homePage.dart';
import 'package:tuple/tuple.dart';
import 'package:intl/intl.dart';

class TaskPage extends StatefulWidget {
  Task task;

  TaskStatus modifiedStatus = TaskStatus.Open;
  Set<Tuple2<TaskRelation, Task>> modifiedRelatedTasks = new Set();

  TaskRelation selectedRelation = TaskRelation.SubTask;
  Task? selectedTask;

  TaskPage({super.key, required this.task}) {
    modifiedStatus = task.status;
    modifiedRelatedTasks = task.relatedTasks;
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
                              content:
                                  Text("Task '${widget.task.title}' deleted!"),
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
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            // Task title
            Padding(
              padding:
                  EdgeInsets.only(left: 4.0, top: 5.0, right: 4.0, bottom: 8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child:
                    Text(widget.task.title, style: TextStyle(fontSize: 20.0)),
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
                child: Text(widget.task.description,
                    style: TextStyle(fontSize: 15.0)),
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
                          widget.modifiedStatus = newValue!;
                        });
                      },
                      value: widget.modifiedStatus,
                      items:
                          TaskStatus.values.map<DropdownMenuItem<TaskStatus>>(
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
                    Text(DateFormat('yyyy-MM-dd  kk:mm')
                        .format(widget.task.updateTime)
                        .toString()),
                  ],
                ),
              ),
            ),
            Divider(),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 5.0, top: 10.0, right: 5.0, bottom: 0.0),
                    child: Text(
                      'Related issues:',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: ListView.builder(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.modifiedRelatedTasks.length,
                      itemBuilder: (context, index) {
                        final task = widget.modifiedRelatedTasks.elementAt(index).item2;
                        Tuple2<TaskRelation, Task> relatedTask =
                            widget.modifiedRelatedTasks.elementAt(index);
                        return Card(
                          elevation: 0,
                          color: Colors.transparent,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          // key: ValueKey(task),
                          child: Row(
                            children: [
                              Text(widget.task.title),
                              Text(relatedTask.item1.value),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TaskPage(task: task),
                                    ),
                                  );
                                },
                                child: Text(relatedTask.item2.title),
                              ),
                              IconButton(
                                onPressed: (){
                                  setState(() {
                                    widget.task.relatedTasks.removeWhere((element) => element == relatedTask);
                                    relatedTask.item2.relatedTasks.removeWhere((element) => element.item1 == relatedTask.item1.relationOpposite && element.item2 == widget.task);
                                  });
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<TaskRelation>(
                    onChanged: (TaskRelation? newValue) {
                      setState(() {
                        widget.selectedRelation = newValue!;
                      });
                    },
                    value: widget.selectedRelation,
                    items:
                        TaskRelation.values.map<DropdownMenuItem<TaskRelation>>(
                      (TaskRelation entry) {
                        return DropdownMenuItem<TaskRelation>(
                          value: entry,
                          child: Text(entry.value),
                        );
                      },
                    ).toList(),
                  ),
                  DropdownButton<Task>(
                    onChanged: (Task? newValue) {
                      setState(() {
                        widget.selectedTask = newValue!;
                      });
                    },
                    value: widget.selectedTask,
                    items: AppState.getFilteredTasks(null)
                        .where((element) => element != widget.task)
                        .map<DropdownMenuItem<Task>>(
                      (Task value) {
                        return DropdownMenuItem<Task>(
                          value: value,
                          child: Text(value.title),
                        );
                      },
                    ).toList(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (widget.selectedTask != null) {
                          widget.modifiedRelatedTasks.add(new Tuple2(
                              widget.selectedRelation, widget.selectedTask!));
                        }
                        widget.selectedTask = null;
                        widget.selectedRelation = TaskRelation.SubTask;
                      });
                    },
                    child: Text('Add'),
                  ),
                ],
              ),
            ),
            Divider(),
            ElevatedButton(
              onPressed: () {
                widget.task.status = widget.modifiedStatus;
                widget.task.updateTime = DateTime.now();
                widget.task.relatedTasks = widget.modifiedRelatedTasks;
                for (int i = 0; i < widget.modifiedRelatedTasks.length; i++) {
                  TaskRelation tempTaskRelation = widget.modifiedRelatedTasks.elementAt(i).item1.relationOpposite;
                  Task relatedTask = widget.modifiedRelatedTasks.elementAt(i).item2;
                  relatedTask.relatedTasks.add(new Tuple2(tempTaskRelation, widget.task));
                }
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
