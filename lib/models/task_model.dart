class Task {
  int _id;
  String _taskName;
  String _taskDescription;
  int _taskCategory;
  String _taskPriority;
  bool _isChecked;

  Task(this._taskName, this._taskDescription, this._taskPriority,
      this._taskCategory, this._isChecked);

  Task.withId(this._id, this._taskName, this._taskDescription,
      this._taskPriority, this._taskCategory, this._isChecked);

  int get id => _id;
  String get taskName => _taskName;
  String get taskDescription => _taskDescription;
  int get taskCategory => _taskCategory;
  String get taskPriority => _taskPriority;
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

  set taskPriority(String newPriority) {
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
    map['name'] = _taskName;
    map['description'] = _taskDescription;
    map['priority'] = _taskPriority;
    map['category_id'] = _taskCategory;
    map['checked'] = (_isChecked) ? 1 : 0;
    return map;
  }

  Task.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._taskName = map['name'];
    this._taskDescription = map['description'];
    this._taskPriority = map['priority'];
    this._taskCategory = map['category_id'];
    this._isChecked = (map['checked'] == 1) ? true : false;
  }
}
