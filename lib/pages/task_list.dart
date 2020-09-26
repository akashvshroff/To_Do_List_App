import 'package:flutter/material.dart';
import 'package:to_do_app/colours.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColorSecondary,
      appBar: AppBar(
        backgroundColor: bgColorPrimary,
        title: Text(
          'tasks',
          style: TextStyle(
            fontSize: 20.0,
            color: textColor,
          ),
        ),
        actions: [],
      ),
    );
  }
}
