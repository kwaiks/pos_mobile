import 'package:pos_mobile/core/utils/constants.dart';

class Menu {
  final int id;
  final String name;
  int storeId;
  final double price;
  final int stock;
  final bool isDiscount;
  final String photo;
  final String description;
  final String code;
  int categoryId;
  final double discountValue;
  final String discountType;
  final bool useInventory;
  List<MenuInventory> inventory;

  Menu(
      {this.id,
      this.name,
      this.storeId,
      this.price,
      this.stock,
      this.isDiscount,
      this.code,
      this.description,
      this.discountType,
      this.discountValue,
      this.photo,
      this.useInventory,
      this.categoryId,
      this.inventory});

  Menu.fromJson(Map<String, dynamic> json)
      : id = json['id'] is int ? json['id'] : int.parse(json['id']),
        name = json['menuName'],
        photo = json['menuPhoto'] == null
            ? ""
            : BASE_PICTURE_URL + json['menuPhoto'],
        storeId = json['storeId'] is int
            ? json['storeId']
            : int.parse(json['storeId']),
        price = json['menuPrice'].toDouble(),
        stock = json['menuStock'],
        description = json['menuDescription'],
        code = json['menuCode'],
        discountType = json['menuDiscountType'],
        categoryId = json['menuCategoryId'] != null
            ? json['menuCategoryId'] is int
                ? json['menuCategoryId']
                : int.parse(json['menuCategoryId'])
            : 0,
        discountValue = json['menuDiscountValue'].toDouble(),
        isDiscount = json['isDiscount'],
        useInventory = json['menuUseInventory'],
        inventory = json['inventory'] != null || json['inventory'].isNotEmpty()
            ? List<MenuInventory>.from(
                json['inventory'].map((item) => MenuInventory.fromJson(item)))
            : [];

  Map<String, dynamic> toJson() => {
        "id": id,
        "storeId": storeId,
        "menuName": name,
        "menuPrice": price,
        "menuStock": stock,
        "menuDescription": description,
        "menuCode": code,
        "menuDiscountType": discountType,
        "menuDiscountValue": discountValue,
        "isDiscount": isDiscount,
        "menuUseInventory": useInventory,
        "menuCategoryId": categoryId,
        "inventory": inventory,
      };
}

class MenuInventory {
  final String name;
  final int stock;
  final int id;
  final int menuId;
  final int inventoryId;
  final String unit;
  int total;

  MenuInventory(
      {this.unit,
      this.id,
      this.menuId,
      this.inventoryId,
      this.total,
      this.name,
      this.stock});

  MenuInventory.fromJson(Map<String, dynamic> json)
      : id = json['id'] != null ? int.parse(json['id']) : 0,
        stock = json['inventoryStock'] != null ? json['inventoryStock'] : 0,
        total = json['inventoryTotal'],
        name = json['inventoryName'] != null ? json['inventoryName'] : "",
        unit = json['inventoryUnit'],
        menuId = json['menuId'] == null
            ? 0
            : json['menuId'] is int
                ? json['menuId']
                : int.parse(json['menuId']),
        inventoryId = json['inventoryId'] is int
            ? json['inventoryId']
            : int.parse(json['inventoryId']);

  Map<String, dynamic> toJson() {
    return {
      "menuId": menuId,
      "inventoryTotal": total,
      "inventoryId": inventoryId
    };
  }
}
