import 'package:flutter/material.dart';
import 'package:pos_mobile/core/enums/state_status.dart';
import 'package:pos_mobile/core/models/inventory.dart';
import 'package:pos_mobile/core/models/user.dart';
import 'package:pos_mobile/core/utils/debouncer.dart';
import 'package:pos_mobile/core/viewmodels/inventory_model.dart';
import 'package:pos_mobile/ui/layout/main_layout.dart';
import 'package:pos_mobile/ui/screens/base_screen.dart';
import 'package:pos_mobile/ui/widgets/text_input.dart';
import 'package:provider/provider.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  InventoryModel _invModel;
  int storeId = 0;

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    storeId = Provider.of<UserStore>(context).id;
    return BaseScreen<InventoryModel>(
      onDestroy: (inv) => {_debouncer.destroy()},
      onModelReady: (inv) {
        inv.getInventories(storeId);
        _invModel = inv;
      },
      builder: (context, model, child) => MainLayout(
        suffix: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: GestureDetector(
              onTap: () => _openDialog(), child: Icon(Icons.add)),
        ),
        title: "Inventory",
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    _debouncer.run(() => model.searchInventoryByName(query));
                  },
                  decoration: InputDecoration(
                      hintText: "Search By Name",
                      contentPadding: const EdgeInsets.all(12),
                      isDense: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0))),
                ),
              ),
              model.state == StateStatus.Loaded
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: model.inventories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return inventoryListItem(
                              model.inventories[index], context);
                        },
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget inventoryListItem(Inventory inv, BuildContext context) {
    return InkWell(
      onTap: () =>
          Navigator.of(context).pushNamed("inventory_detail", arguments: inv),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(8.0),
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: Colors.grey)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(inv.name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(inv.code,
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        color: Colors.black54))
              ],
            ),
            Text("${inv.stock.toString()} ${inv.unit}")
          ],
        ),
      ),
    );
  }

  void _openDialog() {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _codeController = TextEditingController();
    final TextEditingController _minStockController = TextEditingController();
    final TextEditingController _priceController = TextEditingController();
    String unit = "kg";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("New Inventory"),
            actions: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                  onPressed: () {
                    Inventory newInv = Inventory(
                        code: _codeController.text,
                        minStock: int.parse(_minStockController.text),
                        name: _nameController.text,
                        price: double.parse(_priceController.text),
                        storeId: storeId,
                        unit: unit,
                        stock: 0);
                    _invModel.addInventory(newInv);
                    Navigator.of(context).pop();
                  },
                  child: Text("Submit"),
                ),
              )
            ],
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextInput(label: "Name", controller: _nameController),
                    TextInput(
                      label: "Code",
                      controller: _codeController,
                    ),
                    TextInput(
                      label: "Minimum Stock",
                      controller: _minStockController,
                      keyboardType: TextInputType.number,
                    ),
                    Text("Unit",
                        style: TextStyle(fontSize: 14, color: Colors.black54)),
                    DropdownButton(
                        value: unit,
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(
                              value: "kg", child: Text("Kilogram")),
                          DropdownMenuItem(value: "gr", child: Text("Gram")),
                          DropdownMenuItem(
                              value: "ml", child: Text("Milliliter")),
                          DropdownMenuItem(value: "l", child: Text("Liter"))
                        ],
                        onChanged: (val) => setState(() {
                              unit = val;
                            })),
                    TextInput(
                      label: "Base Price",
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }
}
