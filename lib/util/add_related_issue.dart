// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../models/task.dart';
import '../models/task_relation.dart';
import '../screens/task_details.dart';
import 'database_helper.dart';

class AddRelatedIssue extends StatefulWidget {
  AddRelatedIssue({
    Key? key,
    required this.widget,
    required this.task,
    required this.modifiedRelatedTasks,
  }) : super(key: key);

  final TaskDetails widget;
  final Task task;
  Set<Tuple2<TaskRelation, Task>> modifiedRelatedTasks = {};

  @override
  State<AddRelatedIssue> createState() => _AddRelatedIssueState();
}

class _AddRelatedIssueState extends State<AddRelatedIssue> {
  Task? selectedTask;
  TaskRelation selectedRelation = TaskRelation.SubTask;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                    left: 5.0, top: 10.0, right: 5.0, bottom: 0.0),
                child: Text(
                  'Related issues:',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.widget.modifiedRelatedTasks.length,
                  itemBuilder: (context, index) {
                    final task = widget.widget.modifiedRelatedTasks
                        .elementAt(index)
                        .item2;
                    Tuple2<TaskRelation, Task> relatedTask =
                        widget.widget.modifiedRelatedTasks.elementAt(index);
                    return Card(
                      elevation: 0,
                      color: Colors.transparent,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      // key: ValueKey(task),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 100.0,
                            child: Text(
                              widget.widget.task.title,
                            ),
                          ),
                          Container(
                            width: 80.0,
                            child: Text(
                              relatedTask.item1.value,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 100.0,
                            child: TextButton(
                              key: const Key('goToRelatedTask'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TaskDetails(task: task),
                                  ),
                                );
                              },
                              child: Text(
                                relatedTask.item2.title,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                widget.task.relatedTasks.removeWhere(
                                    (element) => element == relatedTask);
                                relatedTask.item2.relatedTasks.removeWhere(
                                    (element) =>
                                        element.item1 ==
                                            relatedTask
                                                .item1.relationOpposite &&
                                        element.item2 == widget.task);
                              });
                            },
                            icon: const Icon(Icons.delete),
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
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DropdownButton<TaskRelation>(
              onChanged: (TaskRelation? newValue) {
                setState(() {
                  selectedRelation = newValue!;
                });
              },
              value: selectedRelation,
              items: TaskRelation.values.map<DropdownMenuItem<TaskRelation>>(
                (TaskRelation entry) {
                  return DropdownMenuItem<TaskRelation>(
                    value: entry,
                    child: Text(entry.value),
                  );
                },
              ).toList(),
            ),
            DropdownButton<Task>(
              key: const Key('dropDownLink'),
              onChanged: (Task? newValue) {
                setState(() {
                  selectedTask = newValue!;
                });
              },
              value: selectedTask,
              items: DatabaseHelper.getFilteredTasks(null)
                  .where((element) => element != widget.task)
                  .map<DropdownMenuItem<Task>>(
                (Task value) {
                  return DropdownMenuItem<Task>(
                    value: value,
                    child: Container(
                      width: 150.0,
                      child: Text(
                        value.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
            addRelation(),
          ],
        ),
      ],
    );
  }

  // addRelation method to add the relation between chosen tasks
  ElevatedButton addRelation() {
    return ElevatedButton(
      key: const Key('addRelationButton'),
      onPressed: () {
        setState(() {
          if (selectedTask != null) {
            widget.modifiedRelatedTasks
                .add(Tuple2(selectedRelation, selectedTask!));
          }
          selectedTask = null;
          selectedRelation = TaskRelation.SubTask;
        });
      },
      child: const Text('Add'),
    );
  }
}
