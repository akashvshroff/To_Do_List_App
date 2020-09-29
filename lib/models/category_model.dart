class Category {
  int _categoryId;
  String _categoryName;
  String _categoryColour;

  Category(this._categoryName, this._categoryColour);
  Category.withId(this._categoryName, this._categoryId, this._categoryColour);

  int get categoryId => _categoryId;
  String get categoryName => _categoryName;
  String get categoryColour => _categoryColour;

  set categoryColour(String newColour) {
    this._categoryColour = newColour;
  }

  set categoryName(String newName) {
    this._categoryName = newName;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (categoryId != null) {
      map['id'] = _categoryId;
    }
    map['name'] = _categoryName;
    map['colour'] = _categoryColour;
    return map;
  }

  Category.fromMapObject(Map<String, dynamic> map) {
    this._categoryId = map['id'];
    this._categoryColour = map['colour'];
    this._categoryName = map['name'];
  }
}
