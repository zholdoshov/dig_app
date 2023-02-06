import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/home_page.dart';
import '../screens/task_details.dart';
import 'app_state.dart';

class DeleteTaskButton extends StatelessWidget {
  const DeleteTaskButton({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final TaskDetails widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {
          showCupertinoDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Alert!'),
              content: const Text(
                  'This task will be deleted from your local storage.'),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                CupertinoDialogAction(
                  child: const Text('Delete'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Task '${widget.task.title}' deleted!"),
                      ),
                    );
                    AppState.removeTaskById(widget.task.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.delete),
      ),
    );
  }
}
