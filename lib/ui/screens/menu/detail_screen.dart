import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_mobile/core/models/menu.dart';
import 'package:pos_mobile/core/viewmodels/menu_model.dart';
import 'package:pos_mobile/ui/screens/base_screen.dart';

class MenuDetailScreen extends StatefulWidget {
  final Menu menu;
  MenuDetailScreen({this.menu});

  @override
  _MenuDetailScreenState createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  MenuModel _menuModel;

  @override
  void initState() {
    super.initState();
  }

  int calculateValueAfterDiscount(
      String discType, double price, double discValue) {
    if (discType == "fixed") {
      return (price - discValue).round();
    } else {
      return (price - (price * discValue / 100)).round();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen<MenuModel>(onModelReady: (menu) {
      menu.getMenuDetail(widget.menu.id);
    }, builder: (context, model, child) {
      _menuModel = model;
      return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context)
                    .pushNamed("menu_edit", arguments: model.currentMenu),
                child: Icon(Icons.edit),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () async {
                  if (await model.removeMenu()) {
                    Navigator.of(context).pushReplacementNamed("menu");
                  }
                },
                child: Icon(Icons.delete),
              ),
            )
          ],
          title: Text(
            widget.menu.name,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: model.currentMenu != null
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(
                          width: 100,
                          height: 100,
                          child: model.currentMenu == null ||
                                  model.currentMenu.photo == ""
                              ? Container(
                                  child: Icon(
                                  Icons.image_not_supported,
                                  size: 80,
                                  color: Colors.grey,
                                ))
                              : Image.network(model.currentMenu.photo)),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name", style: TextStyle(fontSize: 16.0)),
                            Text(model.currentMenu.name,
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Code", style: TextStyle(fontSize: 16.0)),
                            Text(model.currentMenu.code,
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Discount", style: TextStyle(fontSize: 16.0)),
                            Text(
                                !model.currentMenu.isDiscount
                                    ? "No"
                                    : ("Yes " +
                                        (model.currentMenu.discountType ==
                                                "fixed"
                                            ? "(Rp ${model.currentMenu.discountValue})"
                                            : "(${model.currentMenu.discountValue} %)")),
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Price",
                                      style: TextStyle(fontSize: 16.0)),
                                  Text(
                                      'Rp ${model.currentMenu.price.toString()}',
                                      style: TextStyle(fontSize: 20.0))
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Current Price",
                                      style: TextStyle(fontSize: 16.0)),
                                  model.currentMenu.isDiscount
                                      ? Text(
                                          'Rp ${calculateValueAfterDiscount(model.currentMenu.discountType, model.currentMenu.price, model.currentMenu.discountValue)}',
                                          style: TextStyle(fontSize: 20.0))
                                      : Text(
                                          'Rp ${model.currentMenu.price.toString()}',
                                          style: TextStyle(fontSize: 20.0))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Description",
                                style: TextStyle(fontSize: 16.0)),
                            Text(model.currentMenu.description,
                                style: TextStyle(fontSize: 18.0))
                          ],
                        ),
                      ),
                      model.currentMenu.useInventory
                          ? _estimatedStock(model.currentMenu)
                          : _fixedStock(model.currentMenu)
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      );
    });
  }

  Widget _estimatedStock(Menu menu) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Estimated Stock", style: TextStyle(fontSize: 16.0)),
              Tooltip(
                  showDuration: Duration(seconds: 3),
                  child: Icon(
                    Icons.info_outline,
                    size: 14.0,
                  ),
                  message: "Stock based on your current Inventory stock")
            ],
          ),
          Text(menu.stock.toString(), style: TextStyle(fontSize: 18.0)),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text("Inventories", style: TextStyle(fontSize: 16.0)),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: menu.inventory.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 0.0)),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            menu.inventory[index].name,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                              "Current Stock : " +
                                  menu.inventory[index].stock.toString() +
                                  " " +
                                  menu.inventory[index].unit,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14))
                        ],
                      ),
                      Text(
                        menu.inventory[index].total.toString() +
                            " " +
                            menu.inventory[index].unit,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget _fixedStock(Menu menu) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Current Stock", style: TextStyle(fontSize: 16.0)),
          Text(menu.stock.toString(), style: TextStyle(fontSize: 18.0)),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10),
            child: TextButton(
              onPressed: () => _editStockModal(),
              child: Text("Add / Reduce Stock"),
            ),
          )
        ],
      ),
    );
  }

  void _editStockModal() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final TextEditingController _stockController =
              TextEditingController();
          final TextEditingController _descController = TextEditingController();
          bool _addStockToggle = true;
          return AlertDialog(
            title: Text("Edit Stock"),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        isDense: true,
                        labelText: "Total",
                        contentPadding: const EdgeInsets.all(8.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextField(
                      controller: _descController,
                      maxLines: 2,
                      decoration: InputDecoration(
                          isDense: true,
                          labelText: "Description",
                          contentPadding: const EdgeInsets.all(8.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Row(
                    children: [
                      Radio(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: true,
                          groupValue: _addStockToggle,
                          onChanged: (val) => setState(() {
                                _addStockToggle = val;
                              })),
                      Text("Add Stock", style: TextStyle(fontSize: 14)),
                      Radio(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: false,
                          groupValue: _addStockToggle,
                          onChanged: (val) => setState(() {
                                _addStockToggle = val;
                              })),
                      Text("Reduce Stock", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        _menuModel.editStock(
                            description: _descController.text,
                            menuId: _menuModel.currentMenu.id,
                            stock: _addStockToggle
                                ? int.parse(_stockController.text)
                                : int.parse("-" + _stockController.text));
                        Navigator.of(context).pop();
                      },
                      child: Text("Submit"),
                    ),
                  )
                ],
              );
            }),
          );
        });
  }
}
