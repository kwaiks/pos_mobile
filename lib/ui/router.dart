import 'package:flutter/material.dart';
import 'package:pos_mobile/core/models/user.dart';
import 'package:pos_mobile/ui/screens/category/main_screen.dart';
import 'package:pos_mobile/ui/screens/home_screen.dart';
import 'package:pos_mobile/ui/screens/auth/login_screen.dart';
import 'package:pos_mobile/ui/screens/inventory/detail_screen.dart';
import 'package:pos_mobile/ui/screens/inventory/main_screen.dart';
import 'package:pos_mobile/ui/screens/menu/detail_screen.dart';
import 'package:pos_mobile/ui/screens/menu/edit_screen.dart';
import 'package:pos_mobile/ui/screens/menu/main_screen.dart';
import 'package:pos_mobile/ui/screens/splash_screen.dart';
import 'package:pos_mobile/ui/screens/auth/store_select_screen.dart';
import 'package:pos_mobile/ui/screens/store/information_screen.dart';
import 'package:pos_mobile/ui/screens/store/main_screen.dart';
import 'package:pos_mobile/ui/screens/transaction/cart_screen.dart';
import 'package:pos_mobile/ui/screens/transaction/main_screen.dart';

const String initialRoute = "splash";

class StoreListArguments {
  final List<UserStore> storeList;
  StoreListArguments(this.storeList);
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "splash":
        return MaterialPageRoute(builder: (_) => SplashScreenView());
      case "login":
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case "select_store":
        return MaterialPageRoute(
            builder: (_) => StoreSelectScreen(settings.arguments));
      case "menu":
        return MaterialPageRoute(builder: (_) => MenuScreen());
      case "menu_detail":
        return MaterialPageRoute(
            builder: (_) => MenuDetailScreen(
                  menu: settings.arguments,
                ));
      case "menu_edit":
        return MaterialPageRoute(
            builder: (_) => MenuEditScreen(
                  menu: settings.arguments,
                ));
      case "home":
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case "inventory":
        return MaterialPageRoute(builder: (_) => InventoryScreen());
      case "inventory_detail":
        return MaterialPageRoute(
            builder: (_) => InventoryDetailScreen(
                  inv: settings.arguments,
                ));
      case "category":
        return MaterialPageRoute(builder: (_) => CategoryScreen());
      case "store":
        return MaterialPageRoute(builder: (_) => StoreScreen());
      case "store_information":
        return MaterialPageRoute(builder: (_) => StoreInformationScreen());
      case "transaction":
        return MaterialPageRoute(builder: (_) => TransactionScreen());
      case "cart":
        return MaterialPageRoute(builder: (_) => CartScreen());
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}
