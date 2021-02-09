import 'package:flutter/material.dart';
import 'package:pos_mobile/core/enums/state_status.dart';
import 'package:pos_mobile/core/models/cart.dart';
import 'package:pos_mobile/core/models/menu.dart';
import 'package:pos_mobile/core/models/user.dart';
import 'package:pos_mobile/core/services/providers.dart';
import 'package:pos_mobile/core/utils/debouncer.dart';
import 'package:pos_mobile/core/utils/shared_preference.dart';
import 'package:pos_mobile/core/viewmodels/transaction_model.dart';
import 'package:pos_mobile/injector.dart';
import 'package:pos_mobile/ui/layout/main_layout.dart';
import 'package:pos_mobile/ui/screens/base_screen.dart';
import 'package:provider/provider.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final Providers _providers = injector<Providers>();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  final TextEditingController _searchController = TextEditingController();
  int storeId = 0;
  TransactionModel trxModel;

  void moveToCartScreen() async {
    await Navigator.pushNamed(context, "cart");
    setState(() {}); // refresh cart
  }

  @override
  Widget build(BuildContext context) {
    storeId = Provider.of<UserStore>(context).id;
    return BaseScreen<TransactionModel>(onDestroy: (trx) {
      _providers.setCart(trx.cart);
    }, onModelReady: (trx) {
      trx.loadCart(Provider.of<List<Cart>>(context));
      trx.getMenus(storeId);
    }, builder: (context, model, child) {
      trxModel = model;
      return MainLayout(
        fab: model.cart.length > 0
            ? FloatingActionButton(
                onPressed: () {
                  moveToCartScreen();
                },
                child: Stack(
                  children: [
                    Icon(Icons.shopping_cart),
                    Positioned(
                        bottom: 0.0,
                        right: 0.0,
                        child: Container(
                            height: 16,
                            width: 16,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.red),
                            child: Text(
                              model.cartCount.toString(),
                              style:
                                  TextStyle(fontSize: 10, letterSpacing: -0.5),
                            )))
                  ],
                ),
              )
            : null,
        title: "Orders",
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: model.state == StateStatus.Preparing
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (query) {
                              _debouncer.run(() => {});
                            },
                            decoration: InputDecoration(
                                hintText: "Search By Name",
                                contentPadding: const EdgeInsets.all(12),
                                isDense: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.0))),
                          ),
                        ),
                        GridView.builder(
                            itemCount: model.menuList.length,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 4,
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.7,
                                    crossAxisSpacing: 20),
                            itemBuilder: (BuildContext context, int index) {
                              return menuItem(model.menuList[index], model);
                            }),
                      ],
                    ),
                  )),
      );
    });
  }

  void _editMenu() {
    TextEditingController _stockController =
        TextEditingController(text: trxModel.currentCart.quantity.toString());
    showDialog(
        context: context,
        child: AlertDialog(
          actions: [
            TextButton(
              onPressed: () async {
                await trxModel.removeItem(trxModel.currentCart.menu);
                Navigator.pop(context);
              },
              child: Text("Remove"),
            ),
            TextButton(
              onPressed: () async {
                await trxModel.setQuantity(trxModel.currentCart.menu,
                    int.parse(_stockController.text));
                Navigator.pop(context);
              },
              child: Text("Set"),
            ),
          ],
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(trxModel.currentCart.menu.name),
          content: TextField(
            controller: _stockController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Quantity"),
          ),
        ));
  }

  int discountValue(Menu menu) {
    return (menu.discountType == "fixed"
            ? (menu.price - menu.discountValue)
            : (menu.price * ((100 - menu.discountValue) / 100)))
        .toInt();
  }

  Widget menuItem(Menu menu, TransactionModel model) {
    return InkWell(
      onLongPress: () {
        model.setCurrentCart(menu);
        _editMenu();
      },
      onTap: () {
        model.addToCart(menu);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                child: menu.photo == ""
                    ? Container(
                        child: Icon(
                        Icons.image_not_supported,
                        size: 120,
                        color: Colors.grey,
                      ))
                    : Image.network(menu.photo,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.fitWidth),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(menu.name),
                    Text(menu.code),
                    RichText(
                      text: TextSpan(
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          text: menu.isDiscount
                              ? 'Rp ${discountValue(menu)}'
                              : 'Rp ${menu.price.toInt()}'),
                    ),
                    RichText(
                      text: menu.isDiscount
                          ? TextSpan(
                              text: 'Rp ${menu.price.toInt()}',
                              style: TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough))
                          : TextSpan(text: ""),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
