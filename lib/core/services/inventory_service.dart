import 'dart:async';
import 'package:pos_mobile/core/models/inventory.dart';
import 'package:pos_mobile/core/utils/api_helper.dart';
import 'package:pos_mobile/injector.dart';

class InventoryService {
  final APIHelper _apiHelper = injector<APIHelper>();

  Future<List<Inventory>> getMenuInventories(int menuId) async {
    try {
      var response = await _apiHelper.get("/menu/inventories/$menuId");
      return List<Inventory>.from(
          response.map((item) => Inventory.fromJson(item)));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<Inventory>> getInventories(int storeId) async {
    try {
      var response = await _apiHelper.get("/inventory/list/$storeId");
      return List<Inventory>.from(
          response.map((item) => Inventory.fromJson(item)));
    } catch (e) {
      throw e;
    }
  }

  Future<Inventory> addInventory(Inventory inv) async {
    try {
      Map<String, dynamic> reqData = inv.toJson();
      var response = await _apiHelper.post("/inventory/add", data: reqData);
      return Inventory.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<Inventory> editStock(
      {int invId, int stock, String description}) async {
    if (description == null) {
      if (stock < 0) {
        description = "Stock Reduced";
      } else {
        description = "Stock Added";
      }
    }
    try {
      var response = await _apiHelper.post("/inventory/edit-stock",
          data: {"invId": invId, "stock": stock, "description": description});
      return Inventory.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
