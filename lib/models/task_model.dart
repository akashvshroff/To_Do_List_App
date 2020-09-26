class Task {
  int id;
  String taskName;
  String taskDescription;
  int taskCategory;
  int taskPriority;
  bool isChecked;

  Task(this.taskName, this.taskDescription, this.taskPriority,
      this.taskCategory, this.isChecked);
}
