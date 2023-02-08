// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/models/task_relation.dart';
import 'package:myapp/util/app_state.dart';
import 'package:myapp/models/task_status.dart';
import 'package:myapp/screens/home_page.dart';
import 'package:tuple/tuple.dart';
import 'package:intl/intl.dart';

import '../util/add_related_issue.dart';
import '../util/delete_task.dart';

class TaskDetails extends StatefulWidget {
  Task task;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  TaskStatus modifiedStatus = TaskStatus.Open;
  Set<Tuple2<TaskRelation, Task>> modifiedRelatedTasks = {};

  TaskDetails({super.key, required this.task}) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    modifiedStatus = task.status;
    modifiedRelatedTasks = task.relatedTasks;
  }

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  static const String _title = 'Task Details';

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
        title: const Text(_title),
        actions: [
          DeleteTaskButton(key: const Key('deleteTaskButton'), widget: widget),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Task title
                  TextFormField(
                    key: const Key('taskTitleEdit'),
                    decoration: const InputDecoration(
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
                    key: const Key('taskDescriptionEdit'),
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
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
            const Divider(),
            // Task status and last updated time
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Status: '),
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Last update: '),
                  Text(DateFormat('yyyy-MM-dd  kk:mm')
                      .format(widget.task.updateTime)
                      .toString()),
                ],
              ),
            ),
            const Divider(),
            AddRelatedIssue(
              widget: widget,
              task: widget.task,
              modifiedRelatedTasks: widget.modifiedRelatedTasks,
            ),
            const Divider(),
            updateTask(context),
          ],
        ),
      ),
    );
  }

  // updateTask method to update changes in existing task
  ElevatedButton updateTask(BuildContext context) {
    return ElevatedButton(
      key: const Key('taskUpdateButton'),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          widget.task.title = widget._titleController.value.text;
          widget.task.description = widget._descriptionController.value.text;
          widget.task.status = widget.modifiedStatus;
          widget.task.updateTime = DateTime.now();
          widget.task.relatedTasks = widget.modifiedRelatedTasks;
          for (int i = 0; i < widget.modifiedRelatedTasks.length; i++) {
            TaskRelation tempTaskRelation =
                widget.modifiedRelatedTasks.elementAt(i).item1.relationOpposite;
            Task relatedTask = widget.modifiedRelatedTasks.elementAt(i).item2;
            relatedTask.relatedTasks.add(Tuple2(tempTaskRelation, widget.task));
          }
          AppState.sortTasks();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Task updated!"),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      },
      child: const Text('Update task'),
    );
  }
}
