// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/main.dart';
import 'package:go_router/go_router.dart';

class FeedPage extends StatefulWidget {
  int index;
  FeedPage({Key? key, required this.index}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  int currentBotNavIndex = 1;

  final _taskBox = Hive.box('task_box');

  List<Map<String, dynamic>> _listTask = [];

  Map<String, dynamic> _currentTask = {};

  @override
  void initState() {
    super.initState();
    // DatabaseHelper().refreshItems();
    final data = _taskBox.keys.map((key) {
      final item = _taskBox.get(key);
      return {
        "key": key,
        "title": item["title"],
        "description": item["description"],
        "status": item["status"],
        "lastUpdate": item["lastUpdate"]
      };
    }).toList();
    _listTask = data.reversed.toList();
    _currentTask = _listTask[widget.index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
      ),
      body: Center(
        child: Text(_currentTask['title'].toString()),
      ),
      bottomNavigationBar: bottomNav(),
    );
  }

  BottomNavigationBar bottomNav() {
    return BottomNavigationBar(
      currentIndex: currentBotNavIndex,
      showUnselectedLabels: false,
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
      onTap: (index) {
        context.push(routes[index].path);
      },
    );
  }
}
