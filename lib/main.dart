import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/homePage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
      textTheme: TextTheme(
        headline1: TextStyle(color: Colors.deepPurple),
      ),
    ),
    title: 'Task App',
    home: MainPage(),
));
}
