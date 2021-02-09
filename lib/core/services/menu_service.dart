import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pos_mobile/core/models/menu.dart';
import 'package:pos_mobile/core/utils/api_helper.dart';
import 'package:pos_mobile/injector.dart';

class MenuService {
  final APIHelper _apiHelper = injector<APIHelper>();

  Future<List<Menu>> getMenus(int storeId) async {
    try {
      var response = await _apiHelper.get("/menu/list/$storeId");
      return List<Menu>.from(response.map((item) => Menu.fromJson(item)));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Menu> getMenuDetail(int menuId) async {
    try {
      var response = await _apiHelper.get("/menu/detail/$menuId");
      return Menu.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future addMenu(Menu menu, File image) async {
    Map<String, dynamic> reqData = {"data": jsonEncode(menu)};
    if (image != null) {
      reqData["image"] = await MultipartFile.fromFile(image.path);
    }
    try {
      FormData request = FormData.fromMap(reqData);
      await _apiHelper.post("/menu/add", data: request);
    } catch (e) {
      throw e;
    }
  }

  Future editMenu(Menu menu, File image) async {
    Map<String, dynamic> reqData = {"data": jsonEncode(menu)};
    if (image != null) {
      reqData["image"] = await MultipartFile.fromFile(image.path);
    }
    try {
      FormData request = FormData.fromMap(reqData);
      await _apiHelper.post("/menu/edit", data: request);
    } catch (e) {
      throw e;
    }
  }

  Future deleteMenu(int menuId) async {
    try {
      await _apiHelper.delete("/menu/remove/$menuId");
    } catch (e) {
      throw e;
    }
  }

  Future<Menu> editStock({int menuId, int stock, String description}) async {
    if (description == null) {
      if (stock < 0) {
        description = "Stock Reduced";
      } else {
        description = "Stock Added";
      }
    }
    try {
      var response = await _apiHelper.post("/menu/edit-stock",
          data: {"menuId": menuId, "stock": stock, "description": description});
      return Menu.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
