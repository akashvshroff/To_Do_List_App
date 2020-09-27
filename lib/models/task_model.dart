class Task {
  int _id;
  String _taskName;
  String _taskDescription;
  int _taskCategory;
  int _taskPriority;
  bool _isChecked;

  Task(this._taskName, this._taskDescription, this._taskPriority,
      this._taskCategory, this._isChecked);

  Task.withId(this._id, this._taskName, this._taskDescription,
      this._taskPriority, this._taskCategory, this._isChecked);

  int get id => _id;
  String get taskName => _taskName;
  String get taskDescription => _taskDescription;
  int get taskCategory => _taskCategory;
  int get taskPriority => _taskPriority;
  bool get isChecked => _isChecked;

  set taskName(String newName) {
    this._taskName = newName;
  }

  set taskCategory(int newCategory) {
    this._taskCategory = newCategory;
  }

  set taskDescription(String newDescription) {
    this._taskDescription = newDescription;
  }

  set taskPriority(int newPriority) {
    this._taskPriority = newPriority;
  }

  set isChecked(bool newChecked) {
    this._isChecked = newChecked;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['taskName'] = _taskName;
    map['taskDescription'] = _taskDescription;
    map['taskPriority'] = _taskPriority;
    map['taskCategory'] = _taskCategory;
    map['isChecked'] = (_isChecked) ? 1 : 0;
    return map;
  }

  Task.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._taskName = map['taskName'];
    this._taskDescription = map['taskDescription'];
    this._taskPriority = map['taskPriority'];
    this._taskCategory = map['taskCategory'];
    this._isChecked = (map['isChecked'] == 1) ? true : false;
  }
}
