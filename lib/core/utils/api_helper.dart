import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pos_mobile/core/models/api_response.dart';
import 'package:pos_mobile/core/utils/constants.dart';
import 'package:pos_mobile/core/utils/shared_preference.dart';
import 'package:pos_mobile/injector.dart';

class APIHelper {
  final Dio dio;
  APIHelper({@required this.dio});
  final CustomSharedPreferences _customSharedPreferences =
      injector<CustomSharedPreferences>();

  static String _baseUrl = BASE_URL;
  String _token = "";

  // test purpose
  APIHelper.test({@required this.dio});

  void initializeToken() async {
    String token = await _customSharedPreferences.getToken();
    if (token != null) {
      setToken(token);
    }
    _initApiClient();
  }

  void setToken(String token) {
    _token = token;
  }

  void _initApiClient() {
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      options.headers["Authorization"] = "Bearer " + _token;
      return options;
    }, onResponse: (Response response) {
      return response;
    }, onError: (DioError error) async {
      RequestOptions origin = error.response.request;
      if (error.response.statusCode == 401) {
        try {
          Response<dynamic> data = await dio.get("/auth/refresh");
          setToken(data.data['newToken']);
          _customSharedPreferences.setToken(data.data['newToken']);
          origin.headers["Authorization"] = "Bearer " + data.data['newToken'];
          return dio.request(origin.path, options: origin);
        } catch (err) {
          return err;
        }
      }
      return error;
    }));
    dio.options.baseUrl = _baseUrl;
  }

  Future<dynamic> get(String url) async {
    try {
      final response = await dio.get(url);
      ApiResponse apiResponse = ApiResponse.fromJson(response.data);
      if (apiResponse.status != 200) {
        throw Exception(apiResponse.message);
      }
      return apiResponse.data;
    } on DioError catch (e) {
      print('[API Helper - GET] Connection Exception => ' + e.message);
      throw e;
    }
  }

  Future<dynamic> delete(String url) async {
    try {
      final response = await dio.delete(url);
      ApiResponse apiResponse = ApiResponse.fromJson(response.data);
      if (apiResponse.status != 200) {
        throw Exception(apiResponse.message);
      }
      return apiResponse.data;
    } on DioError catch (e) {
      print('[API Helper - DELETE] Connection Exception => ' + e.message);
      throw e;
    }
  }

  Future<dynamic> post(String url,
      {Map headers, @required data, encoding}) async {
    try {
      final response =
          await dio.post(url, data: data, options: Options(headers: headers));
      ApiResponse apiResponse = ApiResponse.fromJson(response.data);
      if (apiResponse.status != 200) {
        throw Exception(apiResponse.message);
      }
      return apiResponse.data;
    } on DioError catch (e) {
      print('[API Helper - POST] Connection Exception => ' + e.message);
      throw e;
    }
  }
}
