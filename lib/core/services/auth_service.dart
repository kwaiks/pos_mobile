import 'dart:async';
import 'package:pos_mobile/core/models/user.dart';
import 'package:pos_mobile/core/services/providers.dart';
import 'package:pos_mobile/core/utils/api_helper.dart';
import 'package:pos_mobile/core/utils/shared_preference.dart';
import 'package:pos_mobile/injector.dart';

class AuthService {
  final APIHelper _apiHelper = injector<APIHelper>();
  final Providers _providers = injector<Providers>();

  Future<Map<String, dynamic>> login(String email, String password) async {
    CustomSharedPreferences _sharedPreference = new CustomSharedPreferences();
    var req = {"email": email, "password": password};
    try {
      var response = await _apiHelper.post("/auth/login", data: req);
      _apiHelper.setToken(response['token']);
      _providers.setUser(User.fromJson(response['user']));
      _sharedPreference.saveCredentials(
          response['token'], User.fromJson(response['user']));
      return {"success": true, "data": response['user']['stores']};
    } catch (err) {
      print(err);
      return {"success": false, "message": err};
    }
  }

  Future<bool> logout() async {
    CustomSharedPreferences _sharedPreference = new CustomSharedPreferences();
    try {
      await _apiHelper.get("/auth/logout");
      _sharedPreference.removeCredentials();
      return true;
    } catch (err) {
      return false;
    }
  }
}
