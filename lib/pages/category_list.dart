import 'package:flutter/material.dart';
import 'package:to_do_app/colours.dart';
import 'package:to_do_app/models/category_model.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<Category> categoryList = [
    Category("Personal", 1, 'blue'),
    Category("Work", 4, 'red'),
    Category("School", 2, 'green'),
    Category("College", 3, 'yellow'),
    Category("Programming", 5, 'indigo'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColorSecondary,
      appBar: AppBar(
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
          itemCount: categoryList?.length,
          itemBuilder: (context, index) {
            return Card(
              color: bgColorPrimary,
              child: Row(
                children: [
                  Text(
                    categoryList[index].categoryName,
                    style: TextStyle(color: textColor, fontSize: 24.0),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  DropdownButton(
                      hint: Text(
                        categoryList[index].categoryColour,
                        style: TextStyle(
                          color: categoryColorsMap[
                              categoryList[index].categoryColour],
                        ),
                      ),
                      value: categoryList[index].categoryColour,
                      items: categoryColorsList.map((String colour) {
                        return DropdownMenuItem(
                            value: colour,
                            child: Text(
                              colour,
                              style: TextStyle(
                                  color: categoryColorsMap[colour],
                                  fontSize: 20.0),
                            ));
                      }),
                      onChanged: ((String newColour) {
                        categoryList[index].categoryColour = newColour;
                      }))
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueButton,
        onPressed: (() {
          saveColours();
          Navigator.pop(context);
        }),
        child: Icon(
          Icons.check,
          color: textColor,
        ),
      ),
    );
  }

  void saveColours() {
    //saves all the colour changes
  }
}
