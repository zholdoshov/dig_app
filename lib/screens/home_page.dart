// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:myapp/models/task_model.dart';
import 'package:myapp/screens/task_page.dart';
import 'package:myapp/forms/add_task_form.dart';
import 'package:myapp/util/app_state.dart';
import 'package:myapp/models/task_status_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  HomePage createState() => HomePage();
}

class HomePage extends State<MainPage> {
  static const String _title = 'Nurulla';

  final Map<String, TaskStatus?> _filters = {
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
        title: const Text(_title),
        // backgroundColor: Colors.deepPurple,
        leading: GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Coming soon.'),
              ),
            );
          },
          child: const Icon(
            Icons.menu,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Filter by: '),
                DropdownButton<String>(
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFilterValue = newValue;
                      _visibleTasks =
                          AppState.getFilteredTasks(_filters[newValue]);
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
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _visibleTasks.length,
              itemBuilder: (context, index) {
                final task = _visibleTasks[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  key: ValueKey(task.id),
                  child: ListTile(
                    title: Text(task.title),
                    trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskPage(task: task),
                            ),
                          );
                        }),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentBotNavIndex,
        showUnselectedLabels: false,
        onTap: (index) => setState(() => currentBotNavIndex = index),
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Feed',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
