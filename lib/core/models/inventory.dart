class Inventory {
  final int id;
  final String name;
  int storeId;
  final int minStock;
  final int stock;
  final double price;
  final String unit;
  final String code;

  Inventory(
      {this.id,
      this.code,
      this.storeId,
      this.minStock,
      this.name,
      this.price,
      this.stock,
      this.unit});

  Inventory.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        storeId = json['storeId'] is int
            ? json['storeId']
            : int.parse(json['storeId']),
        code = json['inventoryCode'],
        minStock = json['inventoryMinStock'],
        stock = json['inventoryStock'],
        price = json['inventoryPrice'].toDouble(),
        name = json['inventoryName'],
        unit = json['inventoryUnit'];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "storeId": storeId,
      "inventoryStock": stock,
      "inventoryPrice": price,
      "inventoryName": name,
      "inventoryCode": code,
      "inventoryMinStock": minStock,
      "inventoryUnit": unit,
    };
  }
}
