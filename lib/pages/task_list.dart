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
  String categoryChoice;
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
                      value: instance.categoryName,
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
              filterTasks('');
            },
            color: textColor,
          ),
          IconButton(
              icon: Icon(
                Icons.category,
                color: textColor,
              ),
              onPressed: () {
                editCategories();
              })
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 4.0, 0, 0),
        child: ListView.builder(
          itemCount: this.taskCount,
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
                            updateChecked(index);
                          });
                        },
                        activeColor:
                            getActiveColor(this.taskList[index].taskPriority),
                      ),
                    ),
                    Flexible(
                      child: ListTile(
                        onTap: () async {
                          String name = '';
                          name = await getCategoryNameDb(
                              this.taskList[index].taskCategory);
                          editTask(
                              'EDIT TASK',
                              this.taskList[index].taskName,
                              this.taskList[index].taskDescription,
                              this.taskList[index].taskPriority,
                              name,
                              this.taskList[index].id);
                        },
                        title: Text(
                          this.taskList[index].taskName,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 19.0,
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
          editTask('ADD TASK', '', '', 'Normal', '');
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

  Color getActiveColor(String priority) {
    Color colourDisplay;
    colourDisplay = (priority == 'Normal') ? blueButton : redButton;
    return colourDisplay;
  }

  void deleteTask(int index) async {
    int result = await databaseHelper.deleteTask(this.taskList[index].id);
    if (result != 0) {
      showSnackBar(context, 'Success: Task Deleted.', true);
    }
    updateList();
  }

  void updateChecked(int index) async {
    int result = await databaseHelper.updateTask(this.taskList[index]);
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

  Future<String> getCategoryNameDb(int id) async {
    String categoryName = await databaseHelper.getCategoryName(id);
    return categoryName;
  }

  Future<int> getCategoryId(String category) async {
    int categoryId = await databaseHelper.getCategoryId(category);
    return categoryId;
  }

  void filterTasks(String category) async {
    await updateList();
    if (category != '') {
      int filteredId = await getCategoryId(category);
      List<Task> filtered = [];
      int count = taskCount;
      for (int i = 0; i < count; i++) {
        if (this.taskList[i].taskCategory == filteredId) {
          filtered.add(this.taskList[i]);
        }
      }
      if (filtered.isEmpty) {
        showSnackBar(context, "Error, no tasks of this category exist.", false);
        setState(() {
          categoryChoice = null;
        });
      } else {
        setState(() {
          this.taskList = filtered;
          this.taskCount = this.taskList.length;
          categoryChoice = category;
        });
      }
    } else {
      setState(() {
        categoryChoice = null;
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

  void editCategories() async {
    var result = Navigator.pushNamed(context, '/category_list');
    updateList();
  }

  void editTask(String title, String name, String description, String priority,
      String category,
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
