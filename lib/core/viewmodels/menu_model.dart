import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pos_mobile/core/enums/state_status.dart';
import 'package:pos_mobile/core/models/category.dart';
import 'package:pos_mobile/core/models/inventory.dart';
import 'package:pos_mobile/core/models/menu.dart';
import 'package:pos_mobile/core/models/user.dart';
import 'package:pos_mobile/core/services/category_service.dart';
import 'package:pos_mobile/core/services/inventory_service.dart';
import 'package:pos_mobile/core/services/menu_service.dart';
import 'package:pos_mobile/core/viewmodels/base_model.dart';
import 'package:pos_mobile/injector.dart';
import 'package:provider/provider.dart';

class MenuModel extends BaseModel {
  final MenuService _menuService = injector<MenuService>();
  final InventoryService _inventoryService = injector<InventoryService>();
  final CategoryService _categoryService = injector<CategoryService>();

  Menu currentMenu;
  List<Menu> defaultList;
  List<Menu> menuList;
  List<Inventory> storeInventory = [];
  List<Inventory> menuInventory = [];
  List<Category> categories = [];
  String errorMessage;

  Future getMenus(BuildContext context) async {
    setState(StateStatus.Preparing);
    int storeId = Provider.of<UserStore>(context).id;
    try {
      defaultList = await _menuService.getMenus(storeId);
      menuList = defaultList;
    } catch (e) {
      menuList = [];
    }
    setState(StateStatus.Loaded);
  }

  Future getMenuDetail(int menuId) async {
    setState(StateStatus.Preparing);
    try {
      currentMenu = await _menuService.getMenuDetail(menuId);
    } catch (e) {
      currentMenu = null;
    }
    setState(StateStatus.Loaded);
  }

  Future getList(BuildContext context) async {
    setState(StateStatus.Preparing);
    int storeId = Provider.of<UserStore>(context).id;
    try {
      storeInventory = await _inventoryService.getInventories(storeId);
      categories = await _categoryService.getCategories(storeId);
    } catch (err) {
      print(err);
      storeInventory = [];
      categories = [];
    }
    setState(StateStatus.Loaded);
  }

  void searchMenuByName(String name) {
    setState(StateStatus.Preparing);
    List<Menu> newList = defaultList
        .where((menu) => menu.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
    menuList = newList;
    setState(StateStatus.Loaded);
  }

  Future<bool> saveMenu(Menu menu, File image) async {
    setState(StateStatus.Preparing);
    try {
      if (currentMenu == null) {
        await _menuService.addMenu(menu, image);
      } else {
        await _menuService.editMenu(menu, image);
      }
      setState(StateStatus.Loaded);
      return true;
    } catch (e) {
      setState(StateStatus.Loaded);
      errorMessage = e;
      return false;
    }
  }

  Future<void> editStock({int menuId, int stock, String description}) async {
    setState(StateStatus.Preparing);
    try {
      currentMenu = await _menuService.editStock(
          description: description, menuId: menuId, stock: stock);
      setState(StateStatus.Loaded);
    } catch (e) {
      setState(StateStatus.Loaded);
      errorMessage = e;
    }
  }

  Future<bool> removeMenu() async {
    setState(StateStatus.Preparing);
    try {
      await _menuService.deleteMenu(currentMenu.id);
      setState(StateStatus.Loaded);
      return true;
    } catch (e) {
      setState(StateStatus.Loaded);
      errorMessage = e;
      return false;
    }
  }
}
