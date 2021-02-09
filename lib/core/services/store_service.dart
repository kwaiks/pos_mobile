import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pos_mobile/core/models/store.dart';
import 'package:pos_mobile/core/utils/api_helper.dart';
import 'package:pos_mobile/injector.dart';

class StoreService {
  final APIHelper _apiHelper = injector<APIHelper>();

  Future<Store> getStore(int storeId) async {
    try {
      var response = await _apiHelper.get("/store/detail/$storeId");
      return Store.fromJson(response);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future editStore(Store store, File image) async {
    Map<String, dynamic> reqData = {"data": jsonEncode(store)};
    if (image != null) {
      reqData["image"] = await MultipartFile.fromFile(image.path);
    }
    try {
      FormData request = FormData.fromMap(reqData);
      await _apiHelper.post("/store/edit", data: request);
    } catch (e) {
      throw e;
    }
  }

  Future<List<StoreGallery>> getGallery(int storeId) async {
    try {
      var response = await _apiHelper.get("/store/gallery/$storeId");
      return List<StoreGallery>.from(
          response.map((item) => StoreGallery.fromJson(item)));
    } catch (err) {
      throw err;
    }
  }

  Future<StoreGallery> addGallery(StoreGallery media, File image) async {
    Map<String, dynamic> reqData = {"data": jsonEncode(media)};
    if (image != null) {
      reqData["image"] = await MultipartFile.fromFile(image.path);
    }
    try {
      FormData request = FormData.fromMap(reqData);
      var response = await _apiHelper.post("/store/gallery", data: request);
      return StoreGallery.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future removeGallery(int mediaId) async {
    try {
      await _apiHelper.delete("/store/gallery/$mediaId");
      return true;
    } catch (err) {
      throw err;
    }
  }
}
