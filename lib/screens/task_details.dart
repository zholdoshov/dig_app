// ignore_for_file: file_names, must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/models/task_relation.dart';
import 'package:myapp/util/database_helper.dart';
import 'package:myapp/models/task_status.dart';
import 'package:myapp/screens/home_page.dart';
import 'package:tuple/tuple.dart';
import 'package:intl/intl.dart';
import '../util/add_related_issue.dart';
import '../util/delete_task.dart';

class TaskDetails extends StatefulWidget {
  Task task;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  TaskStatus modifiedStatus = TaskStatus.Open;
  Set<Tuple2<TaskRelation, Task>> modifiedRelatedTasks = {};

  File? _image;

  TaskDetails({super.key, required this.task}) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    modifiedStatus = task.status;
    modifiedRelatedTasks = task.relatedTasks;
    _image = task.relatedImage;
  }

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  static const String _title = 'Task Details';

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
        title: const Text(_title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.qr_code),
          ),
          DeleteTaskButton(key: const Key('deleteTaskButton'), widget: widget),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            taskAndDescripForm(),
            const Divider(),
            taskStatus(),
            lastUpdate(),
            const Divider(),
            imagePickerButton(),
            const Divider(),
            relatedPicture(),
            const Divider(),
            addRelatedIssue(),
            const Divider(),
            updateTask(context),
          ],
        ),
      ),
    );
  }

  Column relatedPicture() {
    return Column(
      children: [
        const Center(
          child: Text(
            'Related picture:',
            style: TextStyle(fontSize: 20),
          ),
        ),
        widget._image != null
            ? Image.file(widget._image!)
            : const Text("No image selected"),
      ],
    );
  }

  Row imagePickerButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        pickImgFromGallery(),
        pickImgFromCamera(),
      ],
    );
  }

  MaterialButton pickImgFromCamera() {
    return MaterialButton(
        color: Colors.deepPurple,
        child: const Text("Open Camera",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () {
          pickImage(ImageSource.camera);
        });
  }

  MaterialButton pickImgFromGallery() {
    return MaterialButton(
        color: Colors.deepPurple,
        child: const Text("Open Gallery",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () {
          pickImage(ImageSource.gallery);
        });
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => widget._image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  AddRelatedIssue addRelatedIssue() {
    return AddRelatedIssue(
      widget: widget,
      task: widget.task,
      modifiedRelatedTasks: widget.modifiedRelatedTasks,
    );
  }

  Padding lastUpdate() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Last update: '),
          Text(DateFormat('yyyy-MM-dd  kk:mm')
              .format(widget.task.updateTime)
              .toString()),
        ],
      ),
    );
  }

  Form taskAndDescripForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          taskTextFormField(),
          descriptionTextFormField(),
        ],
      ),
    );
  }

  Padding taskStatus() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Status: '),
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
        ],
      ),
    );
  }

  TextFormField descriptionTextFormField() {
    return TextFormField(
      key: const Key('taskDescriptionEdit'),
      decoration: const InputDecoration(
        labelText: 'Description',
      ),
      maxLines: null,
      maxLength: 500,
      controller: widget._descriptionController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Empty field!';
        }
        return null;
      },
    );
  }

  TextFormField taskTextFormField() {
    return TextFormField(
      key: const Key('taskTitleEdit'),
      decoration: const InputDecoration(
        labelText: 'Title',
      ),
      maxLines: null,
      controller: widget._titleController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Empty field!';
        }
        return null;
      },
    );
  }

  // updateTask method to update changes in existing task
  ElevatedButton updateTask(BuildContext context) {
    return ElevatedButton(
      key: const Key('taskUpdateButton'),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          widget.task.title = widget._titleController.value.text;
          widget.task.description = widget._descriptionController.value.text;
          widget.task.status = widget.modifiedStatus;
          widget.task.updateTime = DateTime.now();
          widget.task.relatedTasks = widget.modifiedRelatedTasks;
          widget.task.relatedImage = widget._image;
          for (int i = 0; i < widget.modifiedRelatedTasks.length; i++) {
            TaskRelation tempTaskRelation =
                widget.modifiedRelatedTasks.elementAt(i).item1.relationOpposite;
            Task relatedTask = widget.modifiedRelatedTasks.elementAt(i).item2;
            relatedTask.relatedTasks.add(Tuple2(tempTaskRelation, widget.task));
          }
          DatabaseHelper.sortTasks();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Task updated!"),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      },
      child: const Text('Update task'),
    );
  }
}
