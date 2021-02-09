import 'package:flutter/material.dart';
import 'package:pos_mobile/core/models/cart.dart';
import 'package:pos_mobile/core/models/menu.dart';
import 'package:pos_mobile/core/viewmodels/transaction_model.dart';
import 'package:pos_mobile/ui/screens/base_screen.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  TransactionModel trxModel;

  @override
  Widget build(BuildContext context) {
    return BaseScreen<TransactionModel>(
      onModelReady: (trx) {
        trx.loadCart(Provider.of<List<Cart>>(context));
        trxModel = trx;
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Confirmation"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Order Details",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Text("${model.cartCount} items",
                            style: TextStyle(fontSize: 16))
                      ],
                    ),
                  ),
                  ListView.builder(
                    itemCount: model.cart.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return _cartItem(model.cart[index]);
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  int discountValue(Menu menu) {
    return (menu.discountType == "fixed"
            ? (menu.price - menu.discountValue)
            : (menu.price * ((100 - menu.discountValue) / 100)))
        .toInt();
  }

  double itemPrice(Menu menu) {
    if (menu.isDiscount) {
      return (menu.discountType == "fixed"
          ? (menu.price - menu.discountValue)
          : (menu.price * ((100 - menu.discountValue) / 100)));
    }
    return menu.price;
  }

  Widget _cartItem(Cart cart) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Container(
            height: 100,
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              ClipRRect(
                borderRadius: new BorderRadius.circular(8.0),
                child: cart.menu.photo == ""
                    ? Container(
                        child: Icon(
                        Icons.image_not_supported,
                        size: 80,
                        color: Colors.grey,
                      ))
                    : Image.network(cart.menu.photo,
                        height: 80, width: 80, fit: BoxFit.cover),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(cart.menu.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0)),
                      RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              style: TextStyle(color: Colors.black),
                              text: cart.menu.isDiscount
                                  ? 'Rp ${discountValue(cart.menu)}'
                                  : 'Rp ${cart.menu.price.toInt()}'),
                          TextSpan(text: "  "),
                          cart.menu.isDiscount
                              ? TextSpan(
                                  text: 'Rp ${cart.menu.price.toInt()}',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough))
                              : TextSpan(text: "")
                        ]),
                      )
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Text("Rp ${itemPrice(cart.menu) * cart.quantity}")],
              )
            ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  if (trxModel.removeFromCart(cart.menu)) {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  color: Colors.red,
                  child: Icon(Icons.remove, size: 16, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(cart.quantity.toString()),
              ),
              GestureDetector(
                onTap: () {
                  trxModel.addToCart(cart.menu);
                },
                child: Container(
                  color: Colors.red,
                  child: Icon(Icons.add, size: 16, color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
