import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/models/taskModel.dart';
import 'package:myapp/screens/taskPage.dart';
import 'package:myapp/screens/homePage.dart';
import 'package:myapp/models/taskRelationModel.dart';
import 'package:myapp/models/taskStatusModel.dart';
import 'package:myapp/util/appState.dart';
import 'package:tuple/tuple.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddTask extends StatefulWidget {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  TaskStatus modifiedStatus = TaskStatus.Open;
  Set<Tuple2<TaskRelation, Task>> modifiedRelatedTasks = new Set();

  TaskRelation selectedRelation = TaskRelation.SubTask;
  Task? selectedTask;

  Task _task = AppState.getFirstTask();

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  static const String _widgetTitle = 'Add task';

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    widget._titleController.dispose();
    widget._descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_widgetTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),
                    controller: widget._titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Empty field!';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    maxLines: 6,
                    controller: widget._descriptionController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Empty field!';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            DropdownButton<TaskStatus>(
              onChanged: (TaskStatus? newValue) {
                setState(() {
                  widget.modifiedStatus = newValue!;
                });
              },
              value: widget.modifiedStatus,
              items: TaskStatus.values.map<DropdownMenuItem<TaskStatus>>(
                    (TaskStatus value) {
                  return DropdownMenuItem<TaskStatus>(
                    value: value,
                    child: Text(value.name),
                  );
                },
              ).toList(),
            ),
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
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
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
                              Text(widget._titleController.value.text),
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
                    items: AppState.getFilteredTasks(null).map<DropdownMenuItem<Task>>(
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
                if (_formKey.currentState!.validate()) {
                  AppState.addTask(widget._titleController.value.text,widget._descriptionController.value.text, widget.modifiedStatus);
                  AppState.getFirstTask().relatedTasks = widget.modifiedRelatedTasks;
                  for (int i = 0; i < widget.modifiedRelatedTasks.length; i++) {
                    TaskRelation tempTaskRelation = widget.modifiedRelatedTasks.elementAt(i).item1;
                    Task tempTask = widget.modifiedRelatedTasks.elementAt(i).item2;
                    tempTask.relatedTasks.add(new Tuple2(tempTaskRelation, AppState.getFirstTask()));
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Task '${widget._titleController.text}' created!"),
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                }
              },
              child: const Text('Add task'),
            ),
          ],
        ),
      ),
    );
  }
}
