import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/taskModel.dart';
import 'package:myapp/homepage.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _formKey = GlobalKey<FormState>();

class AddTask extends StatefulWidget {

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  // call Hive local database
  final taskDB = Hive.box('taskDB');

  static const String _widgetTitle = 'Add task';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String statusDropdownValue = 'open';
  DateTime lastUpdated = DateTime.now();

  List<String> _status = [
    'open',
    'in progress',
    'completed',
  ];

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
        // backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
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
              DropdownButton<String>(
                onChanged: (String? newValue) {
                  setState(() {
                    statusDropdownValue = newValue!;
                  });
                },
                value: statusDropdownValue,
                items: _status.map<DropdownMenuItem<String>>(
                      (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),

              ),
              CupertinoButton(
                child: Text('${lastUpdated.month}/${lastUpdated.day}/${lastUpdated.year}'),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) => SizedBox(
                      height: 250,
                      child: CupertinoDatePicker(
                        backgroundColor: Colors.white,
                        initialDateTime: lastUpdated,
                        onDateTimeChanged: (DateTime newTime) {
                          setState(() {
                            lastUpdated = newTime;
                          });
                        },
                        mode: CupertinoDatePickerMode.date,
                      ),
                    ),
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    taskDB.add([_titleController.text, _descriptionController.text, statusDropdownValue, lastUpdated]);
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
      ),
    );
  }
}
