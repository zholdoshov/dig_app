// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:myapp/util/show_task_list.dart';
import 'package:myapp/forms/add_task_form.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  MyHomePage createState() => MyHomePage();
}

class MyHomePage extends State<HomePage> {
  static const String _title = 'Nurulla';

  int currentBotNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_title),
        leading: navMenu(context),
      ),
      body: TaskList(),
      floatingActionButton: addTask(context),
      bottomNavigationBar: bottomNav(),
    );
  }

  // navMenu method to show and hide Navigation Menu
  GestureDetector navMenu(BuildContext context) {
    return GestureDetector(
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
    );
  }

  // goToTask method when add FloatingActionButton is pressed
  FloatingActionButton addTask(BuildContext context) {
    return FloatingActionButton(
      key: const Key("addTaskButton"),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTask()),
        );
      },
      child: const Icon(Icons.add),
    );
  }

  // botttomNav method to call BottomNavigationBar widget
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
