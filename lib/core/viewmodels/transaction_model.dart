import 'package:pos_mobile/core/enums/state_status.dart';
import 'package:pos_mobile/core/models/cart.dart';
import 'package:pos_mobile/core/models/menu.dart';
import 'package:pos_mobile/core/services/menu_service.dart';
import 'package:pos_mobile/core/viewmodels/base_model.dart';
import 'package:pos_mobile/injector.dart';

class TransactionModel extends BaseModel {
  final MenuService _menuService = injector<MenuService>();

  String errorMessage = "";
  List<Menu> menuList = [];
  List<Cart> cart = [];
  Cart currentCart;

  int _discountValue(Menu menu) {
    return (menu.discountType == "fixed"
            ? (menu.price - menu.discountValue)
            : (menu.price * ((100 - menu.discountValue) / 100)))
        .toInt();
  }

  // get set
  int get cartCount {
    int total = 0;
    cart.forEach((item) => total += item.quantity);
    return total;
  }

  double get subTotal {
    double total = 0;
    cart.forEach((item) {
      if (item.menu.isDiscount) {
        total += (_discountValue(item.menu) * item.quantity);
      } else {
        total += (item.menu.price * item.quantity);
      }
    });
    return total;
  }

  double get discount {
    double total = 0;
    cart.forEach((item) {
      total += (item.menu.price * item.quantity);
    });
    return total - this.subTotal;
  }

  // end get set

  void loadCart(List<Cart> cartList) {
    setState(StateStatus.Preparing);
    this.cart = cartList;
    setState(StateStatus.Loaded);
  }

  Future getMenus(int storeId) async {
    setState(StateStatus.Preparing);
    try {
      menuList = await _menuService.getMenus(storeId);
    } catch (e) {
      errorMessage = "Error Occurred";
      menuList = [];
    } finally {
      setState(StateStatus.Loaded);
    }
  }

  //For Long Press dialog on main screen
  void setCurrentCart(Menu menu) {
    int menuIndex = cart.indexWhere((m) => m.menu.id == menu.id);
    if (menuIndex > -1) {
      currentCart = cart[menuIndex];
    } else {
      currentCart = Cart(menu: menu, quantity: 0);
    }
  }

  //Remove Item from cart
  void removeItem(Menu menu) {
    int menuIndex = cart.indexWhere((m) => m.menu.id == menu.id);
    if (menuIndex > -1) {
      cart.removeAt(menuIndex);
    }
    setState(StateStatus.Loaded);
  }

  //Set Quantity
  void setQuantity(Menu menu, int total) {
    int menuIndex = cart.indexWhere((m) => m.menu.id == menu.id);
    if (menuIndex > -1) {
      cart[menuIndex].quantity = total;
    } else {
      cart.add(Cart(menu: menu, quantity: total));
    }
    setState(StateStatus.Loaded);
  }

  void addToCart(Menu menu) {
    int existingCartIndex = cart.indexWhere((item) => item.menu.id == menu.id);
    if (existingCartIndex > -1) {
      cart[existingCartIndex].quantity += 1;
    } else {
      cart.add(Cart(menu: menu, quantity: 1));
    }
    setState(StateStatus.Loaded);
  }

  bool removeFromCart(Menu menu) {
    int existingCartIndex = cart.indexWhere((item) => item.menu.id == menu.id);
    if (existingCartIndex > -1) {
      if (cart[existingCartIndex].quantity > 1) {
        cart[existingCartIndex].quantity -= 1;
      } else {
        cart.removeAt(existingCartIndex);
      }
    }
    setState(StateStatus.Loaded);
    return cart.length == 0;
  }
}
