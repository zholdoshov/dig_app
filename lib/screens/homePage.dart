import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/taskModel.dart';
import 'package:myapp/screens/taskPage.dart';
import 'package:myapp/screens/feedPage.dart';
import 'package:myapp/screens/profilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/forms/addTaskForm.dart';
import 'package:myapp/util/appState.dart';
import 'package:myapp/models/taskStatusModel.dart';
import 'package:flutter/services.dart' as rootBundle;


class MainPage extends StatefulWidget {
  HomePage createState() => HomePage();
}

class HomePage extends State<MainPage>{
  _getRequests() async {
  }

  static const String _title = 'Nurulla';

  Map<String, TaskStatus?> _filters = {
    "All": null,
    "Open": TaskStatus.Open,
    "In Progress": TaskStatus.InProgress,
    "Completed": TaskStatus.Completed
  };

  String? _selectedFilterValue = "All";
  List<Task> _visibleTasks = AppState.getFilteredTasks(null);
  int currentBotNavIndex = 0;

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
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Filter by: '),
                DropdownButton<String>(
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFilterValue = newValue;
                      _visibleTasks = AppState.getFilteredTasks(_filters[newValue]);
                    });
                  },
                  value: _selectedFilterValue,
                  items: _filters.keys.map<DropdownMenuItem<String>>(
                        (String entry) {
                          return DropdownMenuItem<String>(
                            value: entry,
                            child: Text(entry),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _visibleTasks.length,
              itemBuilder: (context, index){
                final task = _visibleTasks[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  key: ValueKey(task.id),
                  child: ListTile(
                    title: Text(task.title),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskPage(task: task),
                          ),
                        );
                      }
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
      bottomNavigationBar: BottomNavigationBar (
        currentIndex: currentBotNavIndex,
        showUnselectedLabels: false,
        onTap: (index) => setState(() => currentBotNavIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}