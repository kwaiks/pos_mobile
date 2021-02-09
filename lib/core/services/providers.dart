import 'dart:async';

import 'package:pos_mobile/core/models/cart.dart';
import 'package:pos_mobile/core/models/user.dart';
import 'package:pos_mobile/core/utils/shared_preference.dart';
import 'package:pos_mobile/injector.dart';

class Providers {
  final CustomSharedPreferences _customSharedPreferences =
      injector<CustomSharedPreferences>();

  StreamController<User> userController = StreamController<User>();
  StreamController<UserStore> activeStoreController =
      StreamController<UserStore>();
  StreamController<List<Cart>> cartController = StreamController<List<Cart>>();

  void setUser(User user) {
    userController.add(user);
  }

  void setUserStore(UserStore store) {
    activeStoreController.add(store);
  }

  void setCart(List<Cart> cartList) {
    cartController.add(cartList);
    _customSharedPreferences.setCart(cartList);
  }
}
