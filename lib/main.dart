import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/homepage.dart';

void main() async {
  // initialize hive
  await Hive.initFlutter();

  //open the box
  var box = await Hive.openBox('taskDB');

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Task App',
    home: MainPage(),
));
}
