import 'package:flutter/material.dart';
import 'package:pos_mobile/core/models/user.dart';
import 'package:pos_mobile/core/services/auth_service.dart';
import 'package:pos_mobile/core/viewmodels/base_model.dart';
import 'package:pos_mobile/injector.dart';
import 'package:pos_mobile/core/enums/state_status.dart';

class AuthModel extends BaseModel {
  final AuthService _authService = injector<AuthService>();

  String errorMessage;

  Future login(String email, String password, BuildContext context) async {
    setState(StateStatus.Preparing);
    try {
      Map<String, dynamic> result = await _authService.login(email, password);
      errorMessage = null;
      if (!result['success']) {
        errorMessage = result['message'];
      } else {
        List<UserStore> storeList = List<UserStore>.from(
            result['data'].map((item) => UserStore.fromJson(item)));
        Navigator.of(context).pushNamed("select_store", arguments: storeList);
      }
      setState(StateStatus.Loaded);
    } catch (e) {
      setState(StateStatus.Loaded);
      errorMessage = e;
    }
  }

  Future<bool> logout() async {
    setState(StateStatus.Preparing);
    bool success = await _authService.logout();
    setState(StateStatus.Loaded);
    return success;
  }
}
