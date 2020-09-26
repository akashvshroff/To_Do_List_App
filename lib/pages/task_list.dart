import 'package:flutter/material.dart';
import 'package:to_do_app/colours.dart';
import 'package:to_do_app/models/task_model.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> taskList = [
    Task('Call up Joe', 'Call up asap', 2, 1, false),
    Task('Submit project idea', 'Do the work by tomorrow', 1, 4, false),
  ];
  @override
  Widget build(BuildContext context) {
    taskList.sort((b, a) => a.taskPriority.compareTo(b.taskPriority));
    return Scaffold(
      backgroundColor: bgColorSecondary,
      appBar: AppBar(
        backgroundColor: bgColorPrimary,
        title: Text(
          'TASKS',
          style: TextStyle(
            fontSize: 20.0,
            color: textColor,
          ),
        ),
        centerTitle: true,
        actions: [
          DropdownButton(
            items: null,
            onChanged: null,
            icon: Icon(
              Icons.find_replace,
              color: textColor,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.not_interested,
              color: textColor,
            ),
            onPressed: () {},
            color: textColor,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 4.0, 0, 0),
        child: ListView.builder(
          itemCount: taskList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
              child: Card(
                color: bgColorPrimary,
                child: Row(
                  children: [
                    Theme(
                      data: ThemeData(
                          unselectedWidgetColor:
                              getActiveColor(taskList[index].taskPriority)),
                      child: Checkbox(
                        value: taskList[index].isChecked, //get from class
                        onChanged: (bool value) {
                          setState(() {
                            taskList[index].isChecked = value;
                          });
                        },
                        activeColor:
                            getActiveColor(taskList[index].taskPriority),
                      ),
                    ),
                    Flexible(
                      child: ListTile(
                        onTap: () {
                          editTask(
                              taskList[index].taskName,
                              taskList[index].taskDescription,
                              taskList[index].taskPriority,
                              taskList[index].taskCategory);
                        },
                        title: Text(
                          taskList[index].taskName,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20.0,
                          ),
                        ),
                        subtitle: Text(
                          'Category'.toUpperCase(),
                          style: TextStyle(
                            color: categoryColorsMap['red'],
                          ),
                        ),
                        trailing: IconButton(
                            color: textColor,
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteTask(index);
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          editTask('Task name', 'Task Description', 1, 0);
        },
        child: Icon(
          Icons.add,
          color: textColor,
        ),
        backgroundColor: blueButton,
      ),
    );
  }

  Color getActiveColor(int priority) {
    Color colourDisplay;
    colourDisplay = (priority == 1) ? blueButton : redButton;
    return colourDisplay;
  }

  void deleteTask(int index) {
    setState(() {
      taskList.removeAt(index);
    });
  }

  void updateList() {}

  void editTask(String name, String description, int priority, int category) {
    Map data = {
      'name': name,
      'description': description,
      'priority': priority,
      'category': category
    };
    Navigator.pushNamed(context, '/task_detail', arguments: data);
  }
}
