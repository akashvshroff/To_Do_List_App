import 'package:flutter/material.dart';
import 'package:to_do_app/colours.dart';
import 'package:to_do_app/models/category_model.dart';
import 'package:to_do_app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<Category> categoryList;
  int categoryCount = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future createAlertDialog(BuildContext context) {
    TextEditingController newCategoryName = TextEditingController();
    String newCategoryColour;
    Map returnData = {};
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("ADD CATEGORY"),
              titleTextStyle: TextStyle(color: textColor, fontSize: 24.0),
              backgroundColor: bgColorSecondary,
              content: Container(
                width: 400.0,
                height: 100.0,
                child: Column(
                  children: [
                    SizedBox(
                      child: TextField(
                          controller: newCategoryName,
                          showCursor: false,
                          style: TextStyle(fontSize: 20.0, color: textColor),
                          decoration: InputDecoration(
                            hintText: "Category Name",
                            hintStyle:
                                TextStyle(color: textColor, fontSize: 18.0),
                            fillColor: bgColorPrimary,
                            filled: true,
                          )),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          'Pick Colour',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        DropdownButton(
                          dropdownColor: bgColorPrimary,
                          icon: Icon(Icons.colorize),
                          hint: Text(
                            'Colour',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18.0,
                            ),
                          ),
                          value: newCategoryColour,
                          items: categoryColorsList.map(
                            (colour) {
                              return DropdownMenuItem(
                                  value: colour,
                                  child: Text(
                                    colour,
                                    style: TextStyle(
                                      color: categoryColorsMap[colour],
                                      fontSize: 20.0,
                                    ),
                                  ));
                            },
                          ).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              newCategoryColour = newValue;
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              actions: [
                RaisedButton.icon(
                    color: blueButton,
                    onPressed: () {
                      returnData['name'] = newCategoryName.text.toString();
                      returnData['colour'] = newCategoryColour;
                      Navigator.pop(context, returnData);
                    },
                    icon: Icon(
                      Icons.check,
                      color: textColor,
                    ),
                    label: Text(
                      "ADD",
                      style: TextStyle(color: textColor, fontSize: 18.0),
                    )),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    if (this.categoryList == null) {
      this.categoryList = List<Category>();
      updateList();
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgColorSecondary,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: textColor,
            ),
            onPressed: () {
              addNewCategory();
            },
          ),
        ],
        backgroundColor: bgColorPrimary,
        title: Text(
          'Edit Categories'.toUpperCase(),
          style: TextStyle(color: textColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 2.0),
        child: ListView.builder(
          itemCount: categoryCount,
          itemBuilder: (context, index) {
            return Card(
              color: bgColorPrimary,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                    child: DropdownButton(
                        dropdownColor: bgColorPrimary,
                        hint: Text(
                          this.categoryList[index].categoryColour,
                          style: TextStyle(
                            color: categoryColorsMap[
                                this.categoryList[index].categoryColour],
                          ),
                        ),
                        value: this.categoryList[index].categoryColour,
                        items: categoryColorsList.map((String colour) {
                          return DropdownMenuItem(
                              value: colour,
                              child: Text(
                                colour,
                                style: TextStyle(
                                    color: categoryColorsMap[colour],
                                    fontSize: 20.0),
                              ));
                        }).toList(),
                        onChanged: ((String newColour) {
                          this.categoryList[index].categoryColour = newColour;
                          saveColourChange(index);
                        })),
                  ),
                  Flexible(
                    child: ListTile(
                      title: Text(
                        this.categoryList[index].categoryName,
                        style: TextStyle(color: textColor, fontSize: 24.0),
                      ),
                      trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: textColor,
                          ),
                          onPressed: () {
                            deleteCategory(index);
                          }),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: blueButton,
        onPressed: (() {
          Navigator.pop(context);
        }),
        icon: Icon(
          Icons.check,
          color: textColor,
        ),
        label: Text(
          'DONE',
          style: TextStyle(
            fontSize: 18.0,
            color: textColor,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void addNewCategory() async {
    String newName;
    String newColour;
    Map data = await createAlertDialog(context);
    if (data != null) {
      if (data['name'] == '') {
        showSnackBar(false, "Error, can't have category without a name.");
        return;
      }
      newName = data['name'];
      newColour = (data['colour'] != '') ? data['colour'] : 'grey';
      int count = categoryCount;
      for (int i = 0; i < count; i++) {
        if (this.categoryList[i].categoryName == newName) {
          showSnackBar(false, "Error, this category already exists.");
          return;
        }
      }
      createCategory(newName, newColour);
    }
    updateList();
  }

  void showSnackBar(bool success, String message) {
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

  void createCategory(String categoryName, String categoryColour) async {
    //Creates a new category object and adds it to the db
    Category newCategory = Category(categoryName, categoryColour);
    int result = await databaseHelper.insertCategory(newCategory);
    if (result != 0) {
      showSnackBar(true, "Success. Category added.");
    } else {
      showSnackBar(false, "Error. Could not add.");
    }
    updateList();
  }

  void saveColourChange(int index) async {
    //Updates the db of a colour change for categories
    int result = await databaseHelper.updateCategory(this.categoryList[index]);
    if (result != 0) {
      showSnackBar(true, "Success. Colour changed.");
    } else {
      showSnackBar(false, "Error. Could not change colour.");
    }
    updateList();
  }

  void deleteCategory(int index) async {
    int result = await databaseHelper
        .deleteCategory(this.categoryList[index].categoryId);
    if (result != 0) {
      showSnackBar(true, "Success. Category deleted successfully.");
    } else {
      showSnackBar(false, "Error. Could not delete category.");
    }
    updateList();
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
}
