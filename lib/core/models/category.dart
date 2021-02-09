class Category {
  final int id;
  final String name;
  int storeId;

  Category({this.id, this.name, this.storeId});

  Category.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        name = json['menuCategoryName'],
        storeId = json['storeId'] is int
            ? json['storeId']
            : int.parse(json['storeId']);

  Map<String, dynamic> toJson() {
    return {"storeId": storeId, "menuCategoryName": name};
  }
}
