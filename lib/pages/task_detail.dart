import 'package:flutter/material.dart';
import 'package:to_do_app/colours.dart';
import 'package:to_do_app/models/category_model.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class TaskDetail extends StatefulWidget {
  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  Map data = {};
  DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController taskName = TextEditingController();
  TextEditingController taskDescription = TextEditingController();
  List<Category> categoryList;
  int categoryCount = 0;
  String categoryChoice;
  String priorityLevel;
  List<String> taskPriorities = ["Normal", "Urgent"];

  @override
  Widget build(BuildContext context) {
    if (categoryList == null) {
      categoryList = List<Category>();
      updateList();
    }
    data = ModalRoute.of(context).settings.arguments;
    taskName.text = (taskName.text == '') ? data['name'] : taskName.text;
    taskDescription.text = (taskDescription.text == '')
        ? data['description']
        : taskDescription.text;
    priorityLevel = data['priority'];
    categoryChoice = data['category'];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: bgColorSecondary,
      appBar: AppBar(
        backgroundColor: bgColorPrimary,
        title: Text(
          data['title'].toUpperCase(),
          style: TextStyle(color: textColor),
        ),
        centerTitle: true,
      ),
      body: Container(
          padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 2.0),
          child: Column(
            children: [
              Flexible(
                child: TextField(
                    showCursor: false,
                    style: TextStyle(color: textColor, fontSize: 24.0),
                    controller: taskName,
                    decoration: InputDecoration(
                      hintText: "Task Name",
                      hintStyle: TextStyle(color: textColor, fontSize: 18.0),
                      fillColor: bgColorPrimary,
                      filled: true,
                    )),
              ),
              SizedBox(
                height: 20.0,
              ),
              Flexible(
                child: TextField(
                    showCursor: false,
                    style: TextStyle(color: textColor, fontSize: 24.0),
                    controller: taskDescription,
                    maxLines: 3,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: "Optional Description",
                      hintStyle: TextStyle(color: textColor, fontSize: 18.0),
                      fillColor: bgColorPrimary,
                      filled: true,
                    )),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 100,
                color: bgColorPrimary,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                      child: Text(
                        'Category',
                        style: TextStyle(fontSize: 24.0, color: textColor),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    DropdownButton(
                      hint: Text(
                        getCategoryName(data['category']),
                        style: TextStyle(
                            fontSize: 20.0,
                            color: getCategoryColour(data['category'])),
                      ),
                      dropdownColor: bgColorPrimary,
                      value: categoryChoice,
                      items: this.categoryList?.map((Category instance) {
                            return DropdownMenuItem(
                                value: instance.categoryId,
                                child: Text(
                                  instance.categoryName,
                                  style: TextStyle(
                                      color: getCategoryColour(
                                          instance.categoryId),
                                      fontSize: 20.0),
                                ));
                          })?.toList() ??
                          [],
                      onChanged: ((newValue) {
                        setState(() {
                          categoryChoice = newValue;
                        });
                      }),
                      icon: Icon(
                        Icons.arrow_downward,
                        color: textColor,
                      ),
                      iconSize: 30,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: textColor,
                      ),
                      onPressed: (() {
                        categoryScreen();
                      }),
                      color: textColor,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                color: bgColorPrimary,
                height: 100,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                      child: Text(
                        'Priority ',
                        style: TextStyle(fontSize: 24.0, color: textColor),
                      ),
                    ),
                    SizedBox(
                      width: 60.0,
                    ),
                    DropdownButton(
                        hint: Text(
                          'Pick level',
                          style: TextStyle(fontSize: 20.0, color: textColor),
                        ),
                        icon: Icon(
                          Icons.arrow_downward,
                          color: textColor,
                        ),
                        dropdownColor: bgColorPrimary,
                        value: priorityLevel,
                        items: taskPriorities.map((priority) {
                          return DropdownMenuItem(
                            value: priority,
                            child: Text(priority,
                                style: TextStyle(
                                    fontSize: 24.0,
                                    color: getPriorityColour(priority))),
                          );
                        }).toList(),
                        onChanged: ((String newValue) {
                          setState(() {
                            priorityLevel = newValue;
                          });
                        }))
                  ],
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                RaisedButton(
                  padding:
                      EdgeInsets.symmetric(horizontal: 55.0, vertical: 20.0),
                  onPressed: () {
                    saveTask();
                  },
                  child: Text(
                    "SAVE",
                    style: TextStyle(fontSize: 24.0, color: textColor),
                  ),
                  color: blueButton,
                ),
                RaisedButton(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                  onPressed: () {},
                  child: Text(
                    "DELETE",
                    style: TextStyle(fontSize: 24.0, color: textColor),
                  ),
                  color: redButton,
                ),
              ])
            ],
          )),
    );
  }

  void deleteTask() async {
    moveToPrev();
    if (data['id'] == null) {
      showAlertDialog("Status", "No task was deleted.");
      return;
    }

    int result = await databaseHelper.deleteTask(data['id']);
    if (result != 0) {
      showAlertDialog("Success", "Note deleted succesfully.");
    } else {
      showAlertDialog("Error", "Note cannot be deleted.");
    }
  }

  void moveToPrev() async {
    var result = await Navigator.pop(context);
    updateList();
  }

  void showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: bgColorPrimary,
      title: Text(title.toUpperCase()),
      titleTextStyle: TextStyle(color: textColor, fontSize: 24.0),
      content: Text(
        message,
        style: TextStyle(color: textColor, fontSize: 20.0),
      ),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void saveTask() async {
    moveToPrev();
    int result;
    int categoryId = await getCategoryId(categoryChoice);
    if (data['id'] != null) {
      //updating a task
      Task newTask = Task.withId(data['id'], taskName.text.toString(),
          taskDescription.text.toString(), priorityLevel, categoryId, false);
      result = await databaseHelper.updateTask(newTask);
    } else {
      Task newTask = Task(taskName.text.toString(),
          taskDescription.text.toString(), priorityLevel, categoryId, false);
      result = await databaseHelper.insertTask(newTask);
    }
    if (result != 0) {
      showAlertDialog("Success", "Task saved successfully.");
    } else {
      showAlertDialog("Error", "Task cannot be saved.");
    }
  }

  void updateList() {
    Future<Database> dbFuture = databaseHelper.initialiseDatabase();
    dbFuture.then((database) {
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
    return textColor;
  }

  void categoryScreen() {
    Navigator.pushNamed(context, '/category_list');
  }

  Future<int> getCategoryId(String category) async {
    int categoryId = await databaseHelper.getCategoryId(category);
    return categoryId;
  }

  int getPriorityLevel(String priority) {
    if (priority.toLowerCase() == 'urgent') {
      return 1;
    } else {
      return 2;
    }
  }

  Color getPriorityColour(String priority) {
    Color priorityColour =
        (getPriorityLevel(priority) == 1) ? redButton : blueButton;
    return priorityColour;
  }
}
