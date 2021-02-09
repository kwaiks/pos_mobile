import 'dart:async';
import 'dart:convert';
import 'package:pos_mobile/core/models/category.dart';
import 'package:pos_mobile/core/utils/api_helper.dart';
import 'package:pos_mobile/injector.dart';

class CategoryService {
  final APIHelper _apiHelper = injector<APIHelper>();

  Future<List<Category>> getCategories(int storeId) async {
    try {
      var response = await _apiHelper.get("/menu/categories/$storeId");
      return List<Category>.from(
          response.map((item) => Category.fromJson(item)));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Category> addCategory(Category category) async {
    try {
      Map<String, dynamic> reqData = category.toJson();
      var response = await _apiHelper.post("/menu/category/add", data: reqData);
      return Category.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
