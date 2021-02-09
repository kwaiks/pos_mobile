import 'package:pos_mobile/core/models/cart.dart';
import 'package:pos_mobile/core/models/user.dart';
import 'package:pos_mobile/core/services/providers.dart';
import 'package:pos_mobile/core/utils/constants.dart';
import 'package:pos_mobile/injector.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'dart:convert';

class CustomSharedPreferences {
  SharedPreferences sharedPref;
  CustomSharedPreferences({this.sharedPref});
  final Providers _providers = injector<Providers>();

  Future<String> getToken() async {
    sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString(ACCESS_TOKEN);
  }

  Future<bool> loadUser() async {
    sharedPref = await SharedPreferences.getInstance();
    String user = sharedPref.getString(USER);
    String store = sharedPref.getString(ACTIVE_STORE);
    String cart = sharedPref.getString(CART);
    if (user != null && store != null) {
      _providers.setUser(User.fromJson(jsonDecode(user)));
      _providers.setUserStore(UserStore.fromJson(jsonDecode(store)));
      if (cart != null) {
        _providers.setCart(
            List<Cart>.from(jsonDecode(cart).map((i) => Cart.fromJson(i))));
      } else {
        _providers.setCart([]);
      }
      return true;
    }
    return false;
  }

  Future setActiveStore(UserStore store) async {
    sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString(ACTIVE_STORE, json.encode(store).toString());
  }

  Future setToken(String token) async {
    sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString(ACCESS_TOKEN, token);
  }

  Future saveCredentials(String token, User user) async {
    sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString(ACCESS_TOKEN, token);
    sharedPref.setString(USER, json.encode(user).toString());
  }

  void removeCredentials() async {
    sharedPref = await SharedPreferences.getInstance();
    sharedPref.remove(ACTIVE_STORE);
    sharedPref.remove(ACCESS_TOKEN);
    sharedPref.remove(CART);
    sharedPref.remove(USER);
  }

  Future<void> removeCart() async {
    sharedPref = await SharedPreferences.getInstance();
    sharedPref.remove(CART);
  }

  Future setCart(dynamic cartList) async {
    sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString(CART, jsonEncode(cartList).toString());
  }
}
