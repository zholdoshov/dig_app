import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/models/taskModel.dart';
import 'package:myapp/screens/homePage.dart';
import 'package:myapp/models/taskStatusModel.dart';
import 'package:myapp/util/appState.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddTask extends StatefulWidget {

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {


  static const String _widgetTitle = 'Add task';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TaskStatus _statusDropdownValue = TaskStatus.Open;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_widgetTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),
                    controller: _titleController,
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
                    controller: _descriptionController,
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
                  _statusDropdownValue = newValue!;
                });
              },
              value: _statusDropdownValue,
              items: TaskStatus.values.map<DropdownMenuItem<TaskStatus>>(
                    (TaskStatus value) {
                  return DropdownMenuItem<TaskStatus>(
                    value: value,
                    child: Text(value.name),
                  );
                },
              ).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  AppState.addTask(_titleController.value.text,_descriptionController.value.text, _statusDropdownValue);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Task '${_titleController.text}' created!"),
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
