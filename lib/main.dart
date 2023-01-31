import 'package:flutter/material.dart';
import 'package:myapp/screens/homePage.dart';
import 'package:myapp/screens/profilePage.dart';
import 'package:myapp/screens/feedPage.dart';
import 'package:go_router/go_router.dart';

final _router = GoRouter(initialLocation: '/home', routes: [
  GoRoute(
    path: '/home',
    builder: (context, state) => const MainPage(),
  ),
  GoRoute(
    path: '/feed',
    builder: (context, state) => const FeedPage(),
  ),
  GoRoute(
    path: '/profile',
    builder: (context, state) => const ProfilePage(),
  )
]);

void main() {
  runApp(MaterialApp.router(
    debugShowCheckedModeBanner: false,
    routerConfig: _router,
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
      textTheme: const TextTheme(
        headline1: TextStyle(color: Colors.deepPurple),
      ),
    ),
    title: 'Task App',
    // home: MainPage(),
  ));
}
