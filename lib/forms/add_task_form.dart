import 'package:flutter/material.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/screens/home_page.dart';
import 'package:myapp/models/task_relation.dart';
import 'package:myapp/models/task_status.dart';
import 'package:myapp/util/app_state.dart';
import 'package:tuple/tuple.dart';

// ignore: must_be_immutable
class AddTask extends StatefulWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  static const String _widgetTitle = 'Add task';

  TaskStatus modifiedStatus = TaskStatus.Open;
  Set<Tuple2<TaskRelation, Task>> modifiedRelatedTasks = {};

  AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
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
        title: const Text(AddTask._widgetTitle),
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
                    key: const Key('taskTitle'),
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
                    key: const Key('taskDecription'),
                    decoration: const InputDecoration(
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
            createTask(context),
          ],
        ),
      ),
    );
  }

  // createTask method for the 'Add task' button
  ElevatedButton createTask(BuildContext context) {
    return ElevatedButton(
      key: const Key("createTaskButton"),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          AppState.addTask(widget._titleController.value.text,
              widget._descriptionController.value.text, widget.modifiedStatus);
          AppState.getFirstTask().relatedTasks = widget.modifiedRelatedTasks;
          for (int i = 0; i < widget.modifiedRelatedTasks.length; i++) {
            TaskRelation tempTaskRelation =
                widget.modifiedRelatedTasks.elementAt(i).item1.relationOpposite;
            Task tempTask = widget.modifiedRelatedTasks.elementAt(i).item2;
            tempTask.relatedTasks
                .add(Tuple2(tempTaskRelation, AppState.getFirstTask()));
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Task '${widget._titleController.text}' created!"),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      },
      child: const Text('Add task'),
    );
  }
}
