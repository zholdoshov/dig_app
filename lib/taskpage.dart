import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/taskModel.dart';
import 'package:myapp/homepage.dart';


class TaskPage extends StatefulWidget {

  final int index;

  TaskPage({super.key, required this.index});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  static const String _title = 'Task';

  static final int _TASK_TITLE = 0;
  static final int _TASK_DESCRIPTION = 1;
  static final int _TASK_STATUS = 2;
  static final int _TASK_LAST_UPDATED = 3;

  final taskDB = Hive.box('taskDB');

  DateTime dateTime = DateTime.now();

  List<String> _status = [
    'open',
    'in progress',
    'completed',
  ];

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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Task '${taskDB.getAt(widget.index)[0].toString()}' deleted!"),
                  ),
                );
                taskDB.deleteAt(widget.index);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
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
                child: Text(getData(_TASK_TITLE), style: TextStyle(fontSize: 20.0)),
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
                child: Text(getData(_TASK_DESCRIPTION), style: TextStyle(fontSize: 15.0)),
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
                    DropdownButton<String>(
                      onChanged: (String? newValue) {
                        setState(() {
                          taskDB.getAt(widget.index)[_TASK_STATUS] = newValue!;
                        });
                      },
                      value: taskDB.getAt(widget.index)[_TASK_STATUS],
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
                      child: Text('${getData(_TASK_LAST_UPDATED)}'.split(" ")[0]),
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) => SizedBox(
                            height: 250,
                            child: CupertinoDatePicker(
                              backgroundColor: Colors.white,
                              initialDateTime: taskDB.getAt(widget.index)[_TASK_LAST_UPDATED],
                              onDateTimeChanged: (DateTime newTime) {
                                setState(() {
                                  taskDB.getAt(widget.index)[_TASK_LAST_UPDATED] = newTime;
                                });
                              },
                              mode: CupertinoDatePickerMode.date,
                            ),
                          ),
                        );
                      },
                    ),
                    // Text(getData(_TASK_STATUS), style: TextStyle(fontSize: 15.0)),
                    // Text(getDate()),
                    // Text('Last update: ' + getData(_TASK_LAST_UPDATED), style: TextStyle(fontSize: 15.0)),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                taskDB.putAt(widget.index, [getData(_TASK_TITLE), getData(_TASK_DESCRIPTION), taskDB.getAt(widget.index)[_TASK_STATUS], taskDB.getAt(widget.index)[_TASK_LAST_UPDATED]]);
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

  getData(value) {
    return taskDB.getAt(widget.index)[value].toString();
  }

  getDate() {
    dateTime = DateTime.parse(getData(_TASK_LAST_UPDATED));
    String date = '${dateTime.month}-${dateTime.day}-${dateTime.year}';
    return date;
  }

  getDateToString() {
    dateTime = DateTime.parse(getData(_TASK_LAST_UPDATED));
    String date = '${dateTime.month}-${dateTime.day}-${dateTime.year}';
    return date;
  }
}
