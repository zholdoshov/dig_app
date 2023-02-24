// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/screens/feed_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int currentBotNavIndex = 2;

  final _taskBox = Hive.box('task_box');

  List<Map<String, dynamic>> _listTask = [];

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView.builder(
        itemCount: _listTask.length,
        itemBuilder: (_, index) {
          final currentTask = _listTask[index];
          return Card(
            color: Colors.deepPurple.shade100,
            margin: const EdgeInsets.all(10),
            elevation: 3,
            child: ListTile(
              title: Text(currentTask['title']),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeedPage(index: index),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
              ),
            ),
          );
        },
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
