import 'package:flutter/material.dart';
import 'package:to_do_app/colours.dart';

class TaskDetail extends StatefulWidget {
  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  Map data = {};

  TextEditingController taskName = TextEditingController();
  TextEditingController taskDescription = TextEditingController();
  List categoryList = [];
  String categoryChoice;
  int priorityLevel;

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    taskName.text = (taskName.text == '') ? data['name'] : taskName.text;
    taskDescription.text = (taskDescription.text == '')
        ? data['description']
        : taskDescription.text;
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
                      helperText: "Task Name",
                      helperStyle: TextStyle(color: textColor, fontSize: 18.0),
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
                      helperText: "Optional Description",
                      helperStyle: TextStyle(color: textColor, fontSize: 18.0),
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
                      width: 30.0,
                    ),
                    DropdownButton(
                      hint: Text(
                        'Pick Category',
                        style: TextStyle(fontSize: 14.0, color: textColor),
                      ),
                      dropdownColor: bgColorPrimary,
                      value: categoryChoice,
                      items: ['Personal', 'College', 'School', 'Work']
                          .map((String name) {
                        return DropdownMenuItem(
                            value: name,
                            child: Text(
                              name,
                              style:
                                  TextStyle(color: textColor, fontSize: 24.0),
                            ));
                      }).toList(),
                      onChanged: ((String newValue) {
                        setState(() {
                          categoryChoice = newValue;
                        });
                      }),
                      icon: Icon(
                        Icons.category,
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
                          style: TextStyle(fontSize: 16.0, color: textColor),
                        ),
                        icon: Icon(
                          Icons.arrow_downward,
                          color: textColor,
                        ),
                        dropdownColor: bgColorPrimary,
                        value: priorityLevel,
                        items: ["Normal", "Urgent"].map((priority) {
                          return DropdownMenuItem(
                            value: getPriorityLevel(priority),
                            child: Text(
                              priority,
                              style:
                                  TextStyle(fontSize: 24.0, color: textColor),
                            ),
                          );
                        }).toList(),
                        onChanged: ((int newValue) {
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
                  onPressed: () {},
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

  void categoryScreen() {
    Navigator.pushNamed(context, '/category_list');
  }

  int getPriorityLevel(String priority) {
    if (priority.toLowerCase() == 'urgent') {
      return 1;
    } else {
      return 2;
    }
  }
}
