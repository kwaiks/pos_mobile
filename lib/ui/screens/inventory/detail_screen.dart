import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_mobile/core/models/inventory.dart';
import 'package:pos_mobile/core/viewmodels/inventory_model.dart';
import 'package:pos_mobile/ui/screens/base_screen.dart';

class InventoryDetailScreen extends StatefulWidget {
  final Inventory inv;
  InventoryDetailScreen({this.inv});

  @override
  _InventoryDetailScreenState createState() => _InventoryDetailScreenState();
}

class _InventoryDetailScreenState extends State<InventoryDetailScreen> {
  InventoryModel _invModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen<InventoryModel>(onModelReady: (inv) {
      inv.inventory = widget.inv;
    }, builder: (context, model, child) {
      _invModel = model;
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.inv.name,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: model.inventory != null
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name", style: TextStyle(fontSize: 16.0)),
                            Text(model.inventory.name,
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
                            Text(model.inventory.code,
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
                            Text("Unit", style: TextStyle(fontSize: 16.0)),
                            Text(model.inventory.unit,
                                style: TextStyle(fontSize: 18.0))
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Minimum Stock",
                                style: TextStyle(fontSize: 16.0)),
                            Text(model.inventory.minStock.toString(),
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                      ),
                      _fixedStock(model.inventory)
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

  Widget _fixedStock(Inventory inv) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Stock", style: TextStyle(fontSize: 16.0)),
          Text(inv.stock.toString(), style: TextStyle(fontSize: 18.0)),
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
                        _invModel.editStock(
                            description: _descController.text,
                            invId: _invModel.inventory.id,
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
