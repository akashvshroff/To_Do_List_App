import 'package:flutter/material.dart';
import 'package:to_do_app/colours.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/models/category_model.dart';
import 'package:to_do_app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Task> taskList;
  int taskCount = 0;
  List<Category> categoryList;
  int categoryCount = 0;
  int categoryChoice;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (taskList == null || categoryList == null) {
      taskList = List<Task>();
      categoryList = List<Category>();
      updateList();
    }
    return Scaffold(
      key: _scaffoldKey,
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
        centerTitle: false,
        actions: [
          DropdownButton(
            hint: Text(
              'Filter',
              style: TextStyle(
                color: textColor,
              ),
            ),
            dropdownColor: bgColorPrimary,
            value: categoryChoice,
            items: this.categoryList?.map((Category instance) {
                  return DropdownMenuItem(
                      value: instance.categoryId,
                      child: Text(
                        instance.categoryName,
                        style: TextStyle(
                            color: categoryColorsMap[instance.categoryColour],
                            fontSize: 16.0),
                      ));
                })?.toList() ??
                [],
            onChanged: (newValue) {
              filterTasks(newValue);
            },
            icon: Icon(
              Icons.filter_list,
              color: textColor,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.clear,
              color: textColor,
            ),
            onPressed: () {
              filterTasks(0);
            },
            color: textColor,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 4.0, 0, 0),
        child: ListView.builder(
          itemCount: taskCount,
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
                          unselectedWidgetColor: getActiveColor(
                              this.taskList[index].taskPriority)),
                      child: Checkbox(
                        value: this.taskList[index].isChecked, //get from class
                        onChanged: (bool value) {
                          setState(() {
                            this.taskList[index].isChecked = value;
                          });
                        },
                        activeColor:
                            getActiveColor(this.taskList[index].taskPriority),
                      ),
                    ),
                    Flexible(
                      child: ListTile(
                        onTap: () {
                          editTask(
                              'EDIT TASK',
                              this.taskList[index].taskName,
                              this.taskList[index].taskDescription,
                              this.taskList[index].taskPriority,
                              this.taskList[index].taskCategory,
                              this.taskList[index].id);
                        },
                        title: Text(
                          this.taskList[index].taskName,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20.0,
                          ),
                        ),
                        subtitle: Text(
                          getCategoryName(this.taskList[index].taskCategory)
                              .toUpperCase(), //get category name from db via id
                          style: TextStyle(
                            color: getCategoryColour(taskList[index]
                                .taskCategory), //get category colour from db via id
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
          editTask('ADD TASK', '', '', 2, 0);
        },
        child: Icon(
          Icons.add,
          color: textColor,
        ),
        backgroundColor: blueButton,
      ),
    );
  }

  void showSnackBar(BuildContext context, String message, bool success) {
    Color snackbarColour = success ? greenButton : redButton;
    final snackbar = SnackBar(
        backgroundColor: bgColorPrimary,
        action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              _scaffoldKey.currentState.hideCurrentSnackBar();
            }),
        content: Text(message,
            style: TextStyle(color: snackbarColour, fontSize: 20.0)));
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Color getActiveColor(int priority) {
    Color colourDisplay;
    colourDisplay = (priority == 1) ? blueButton : redButton;
    return colourDisplay;
  }

  void deleteTask(int index) async {
    int result = await databaseHelper.deleteTask(this.taskList[index].id);
    if (result != 0) {
      showSnackBar(context, 'Success: Task Deleted.', true);
    }
    updateList();
  }

  void updateList() {
    Future<Database> dbFuture = databaseHelper.initialiseDatabase();
    dbFuture.then((database) {
      Future<List<Task>> taskListFuture = databaseHelper.getTaskList();
      taskListFuture.then((taskList) {
        setState(() {
          this.taskList = taskList;
          this.taskCount = taskList.length;
        });
      });

      Future<List<Category>> categoryListFuture =
          databaseHelper.getCategoryList();
      categoryListFuture.then((categoryList) {
        setState(() {
          this.categoryList = categoryList;
          this.categoryCount = categoryList.length;
        });
      });
    });
  }

  void filterTasks(int category) {
    updateList();
    if (category != 0) {
      int count = taskCount;
      List<Task> filtered = [];
      for (int i = 0; i < count; i++) {
        if (taskList[i].taskCategory == category) {
          filtered.add(taskList[i]);
        }
      }
      print(filtered);
      setState(() {
        this.taskList = filtered;
      });
    }
  }

  String getCategoryName(int categoryID) {
    int count = categoryCount;
    for (int i = 0; i < count; i++) {
      if (categoryList[i].categoryId == categoryID) {
        return categoryList[i].categoryName;
      }
    }
    return 'Default';
  }

  Color getCategoryColour(int categoryID) {
    int count = categoryCount;
    for (int i = 0; i < count; i++) {
      if (categoryList[i].categoryId == categoryID) {
        return categoryColorsMap[categoryList[i].categoryColour];
      }
    }
    return bgColorPrimary;
  }

  void editTask(
      String title, String name, String description, int priority, int category,
      [int id]) async {
    Map data = {
      'id': id,
      'title': title,
      'name': name,
      'description': description,
      'priority': priority,
      'category': category
    };
    var result =
        await Navigator.pushNamed(context, '/task_detail', arguments: data);
    updateList();
  }
}
