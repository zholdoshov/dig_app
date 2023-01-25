import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/screens/homePage.dart';
import 'package:myapp/screens/profilePage.dart';
import 'package:myapp/screens/feedPage.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';

const _routeTitles = {
  '/home': 'Home Page',
  '/feed': 'Feed Page',
  '/profile': 'Profile Page'
};

final _router = GoRouter(
    initialLocation: '/home',
      routes: [
        GoRoute(
            path: '/home',
            builder: (context, state) => MainPage(),
        ),
        GoRoute(
            path: '/feed',
            builder: (context, state) => const FeedPage(),
        ),
        GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
        )
      ]
);

void main() {
  runApp(MaterialApp.router(
    debugShowCheckedModeBanner: false,
    routerConfig: _router,
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
      textTheme: TextTheme(
        headline1: TextStyle(color: Colors.deepPurple),
      ),
    ),
    title: 'Task App',
    // home: MainPage(),
));
}
