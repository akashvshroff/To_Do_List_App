import 'package:flutter/material.dart';
import 'package:to_do_app/pages/category_list.dart';
import 'package:to_do_app/pages/task_detail.dart';
import 'package:to_do_app/pages/task_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Mono'),
      initialRoute: '/',
      routes: {
        '/': (context) => TaskList(),
        '/task_detail': (context) => TaskDetail(),
        '/category_list': (context) => CategoryList(),
      },
    );
  }
}
