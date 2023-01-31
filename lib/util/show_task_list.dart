// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:myapp/screens/task_details.dart';

import '../models/task_model.dart';
import '../models/task_status_model.dart';
import 'app_state.dart';

class TaskList extends StatefulWidget {
  final Map<String, TaskStatus?> _filters = {
    "All": null,
    "Open": TaskStatus.Open,
    "In Progress": TaskStatus.InProgress,
    "Completed": TaskStatus.Completed
  };

  String _selectedFilterValue = "All";
  List<Task> _visibleTasks = AppState.getFilteredTasks(null);

  TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
                    widget._selectedFilterValue = newValue!;
                    widget._visibleTasks =
                        AppState.getFilteredTasks(widget._filters[newValue]);
                  });
                },
                value: widget._selectedFilterValue,
                items: widget._filters.keys.map<DropdownMenuItem<String>>(
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
            itemCount: widget._visibleTasks.length,
            itemBuilder: (context, index) {
              final task = widget._visibleTasks[index];
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
                            builder: (context) => TaskDetails(task: task),
                          ),
                        );
                      }),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
