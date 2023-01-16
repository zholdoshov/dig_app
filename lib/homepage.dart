import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:myapp/taskModel.dart';
import 'package:myapp/taskpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/addtaskform.dart';
import 'package:flutter/services.dart' as rootBundle;


class MainPage extends StatefulWidget {
  HomePage createState() => HomePage();
}

class HomePage extends State<MainPage>{
  _getRequests() async {
  }

  static const String _title = 'Nurulla';

  static final int _TASK_TITLE = 0;
  static final int _TASK_STATUS = 2;

  final taskDB = Hive.box('taskDB');

  String statusDropdownValue = 'all';

  List<String> _status = [
    'all',
    'open',
    'in progress',
    'completed',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        // backgroundColor: Colors.deepPurple,
        leading: GestureDetector(
          onTap: (){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Coming soon.'),
              ),
            );
          },
          child: Icon(
            Icons.menu,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text('show all'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${taskDB.toMap()}'),
                      ),
                    );
                  }
                ),
                PopupMenuItem(child: Text('open')),
                PopupMenuItem(child: Text('in progress')),
                PopupMenuItem(child: Text('completed')),
              ],
            ),
          ),
        ],
      ),
      body: taskDB.isEmpty ? Center(child: Text('Nothing to do!')) : Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: taskDB.toMap().length,
          itemBuilder: (context, index){
            final task = taskDB.toMap()[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              key: ValueKey(taskDB.getAt(index)[_TASK_TITLE]),
              child: ListTile(
                title: Text(getData(index, _TASK_TITLE)),
                leading: Icon(Icons.assignment),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => taskDB.isEmpty ? Center(child: Text('Nothing to do!')) : TaskPage(index: index),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTask()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  getData(index, value) {
    return taskDB.getAt(index)[value].toString();
  }
}