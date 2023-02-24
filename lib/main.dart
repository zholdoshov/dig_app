import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/screens/home_page.dart';
import 'package:myapp/screens/profile_page.dart';
import 'package:myapp/screens/feed_page.dart';
import 'package:go_router/go_router.dart';

Map<String, dynamic>? task;

final routes = [
  GoRoute(
    path: '/',
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
    path: '/feed',
    builder: (context, state) => const ProfilePage(),
  ),
  GoRoute(
    path: '/profile',
    builder: (context, state) => const ProfilePage(),
  )
];

final _router = GoRouter(initialLocation: '/', routes: routes);

void main() async {
  WidgetsFlutterBinding.ensureInitialized;

  await Hive.initFlutter();
  await Hive.openBox('task_box');

  runApp(MaterialApp.router(
    debugShowCheckedModeBanner: false,
    routerConfig: _router,
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
    title: 'Task App',
  ));
}

class NewWidget extends StatefulWidget {
  const NewWidget({super.key});

  @override
  State<NewWidget> createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  final List<Map<String, dynamic>> _listTask = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Page'),
      ),
      body: ListView.builder(
        itemCount: _listTask.length,
        itemBuilder: (_, index) {
          final currentTask = _listTask[index];
          return Card(
            color: Colors.orange.shade100,
            margin: const EdgeInsets.all(10),
            elevation: 3,
            child: ListTile(
              title: Text(currentTask['title']),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit),
              ),
            ),
          );
        },
      ),
    );
  }
}
