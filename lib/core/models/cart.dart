import 'package:pos_mobile/core/models/menu.dart';

class Cart {
  final Menu menu;
  int quantity;
  String note;
  Cart({this.menu, this.quantity = 1, this.note = ""});

  Cart.fromJson(Map<String, dynamic> json)
      : menu = Menu.fromJson(json['menu']),
        quantity = json['quantity'],
        note = json['note'];

  Map<String, dynamic> toJson() {
    return {"menu": menu, "quantity": quantity, "note": note};
  }
}
