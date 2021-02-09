import 'package:pos_mobile/core/enums/state_status.dart';
import 'package:pos_mobile/core/models/inventory.dart';
import 'package:pos_mobile/core/services/inventory_service.dart';
import 'package:pos_mobile/core/viewmodels/base_model.dart';
import 'package:pos_mobile/injector.dart';

class InventoryModel extends BaseModel {
  final InventoryService _inventoryService = injector<InventoryService>();

  String errorMessage = "";
  Inventory inventory;
  List<Inventory> defaultList = [];
  List<Inventory> inventories = [];

  Future getInventories(int storeId) async {
    setState(StateStatus.Preparing);
    try {
      inventories = await _inventoryService.getInventories(storeId);
      defaultList = inventories;
    } catch (e) {
      errorMessage = e;
    }
    setState(StateStatus.Loaded);
  }

  Future addInventory(Inventory inv) async {
    setState(StateStatus.Preparing);
    try {
      Inventory addedInv = await _inventoryService.addInventory(inv);
      inventories.add(addedInv);
      defaultList.add(addedInv);
      setState(StateStatus.Loaded);
    } catch (e) {
      setState(StateStatus.Loaded);
      errorMessage = e;
    }
  }

  void searchInventoryByName(String name) {
    setState(StateStatus.Preparing);
    List<Inventory> newList = defaultList
        .where((inv) => inv.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
    inventories = newList;
    setState(StateStatus.Loaded);
  }

  Future<void> editStock({int invId, int stock, String description}) async {
    setState(StateStatus.Preparing);
    try {
      inventory = await _inventoryService.editStock(
          description: description, invId: invId, stock: stock);
      setState(StateStatus.Loaded);
    } catch (e) {
      setState(StateStatus.Loaded);
      errorMessage = e;
    }
  }
}
