import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/models/category_model.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //Singleton Database Helper
  static Database _database; //Singleton database

  String taskTable = 'tasks';
  String taskId = 'id';
  String taskCategory = 'category_id';
  String taskName = 'name';
  String taskDescription = 'description';
  String taskPriority = 'priority';
  String taskChecked = 'checked';

  String categoryTable = 'categories';
  String categoryId = 'id';
  String categoryColour = 'colour';
  String categoryName = 'name';

  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      //lazily instantiate first time round
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initialiseDatabase();
    }
    return _database;
  }

  Future<Database> initialiseDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'todo.db';
    var tasksDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return tasksDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(''' 
    CREATE TABLE $taskTable($taskId INTEGER PRIMARY KEY AUTOINCREMENT, $taskName TEXT, $taskDescription TEXT, $taskCategory INTEGER,
    $taskChecked INTEGER, $taskPriority STRING)
    ''');
    await db.execute(
        '''CREATE TABLE $categoryTable($categoryId INTEGER PRIMARY KEY AUTOINCREMENT, $categoryName TEXT UNIQUE, $categoryColour TEXT )''');
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.database;
    var result = await db
        .rawQuery('SELECT * FROM $taskTable ORDER BY $taskPriority DESC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getCategoryMapList() async {
    Database db = await this.database;
    var result = await db
        .rawQuery('SELECT * FROM $categoryTable ORDER BY $categoryName ASC');
    return result;
  }

  Future<int> insertTask(Task task) async {
    Database db = await this.database;
    var result = await db.insert(taskTable, task.toMap());
    return result;
  }

  Future<int> insertCategory(Category category) async {
    Database db = await this.database;
    var result = await db.insert(categoryTable, category.toMap());
    return result;
  }

  Future<int> getCategoryId(String name) async {
    Database db = await this.database;
    var x = await db
        .query(categoryTable, where: '$categoryName = ?', whereArgs: [name]);
    int result;
    x.forEach((element) {
      result = element[categoryId];
    });
    return result;
  }

  Future<String> getCategoryName(int id) async {
    Database db = await this.database;
    var x = await db
        .query(categoryTable, where: '$categoryId = ?', whereArgs: [id]);
    String result;
    x.forEach((element) {
      result = element[categoryId];
    });
    return result;
  }

  Future<int> updateTask(Task task) async {
    Database db = await this.database;
    int result = await db.update(taskTable, task.toMap(),
        where: '$taskId = ?', whereArgs: [task.id]);
    return result;
  }

  Future<int> updateCategory(Category category) async {
    Database db = await this.database;
    int result = await db.update(categoryTable, category.toMap(),
        where: '$categoryId = ?', whereArgs: [category.categoryId]);
    return result;
  }

  Future<int> deleteTask(int id) async {
    Database db = await this.database;
    int result =
        await db.delete(taskTable, where: '$taskId = ?', whereArgs: [id]);
    return result;
  }

  Future<int> deleteCategory(int id) async {
    Database db = await this.database;
    int result = await db
        .delete(categoryTable, where: '$categoryId = ?', whereArgs: [id]);
    return result;
  }

  Future<int> getTaskCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery("SELECT COUNT (*) FROM $taskTable");
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<int> getCategoryCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery("SELECT COUNT (*) FROM $categoryTable");
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Task>> getTaskList() async {
    var taskMapList = await getTaskMapList();
    int count = taskMapList.length;
    List<Task> taskList = List<Task>();
    for (int i = 0; i < count; i++) {
      taskList.add(Task.fromMapObject(taskMapList[i]));
    }
    return taskList;
  }

  Future<List<Category>> getCategoryList() async {
    var categoryMapList = await getCategoryMapList();
    int count = categoryMapList.length;
    List<Category> categoryList = List<Category>();
    for (int i = 0; i < count; i++) {
      categoryList.add(Category.fromMapObject(categoryMapList[i]));
    }
    return categoryList;
  }
}
