import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:pos_mobile/core/enums/state_status.dart';
import 'package:pos_mobile/core/models/inventory.dart';
import 'package:pos_mobile/core/models/menu.dart';
import 'package:pos_mobile/core/models/user.dart';
import 'package:pos_mobile/core/utils/colors.dart';
import 'package:pos_mobile/core/viewmodels/menu_model.dart';
import 'package:pos_mobile/ui/screens/base_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_mobile/ui/widgets/text_input.dart';
import 'package:provider/provider.dart';

class MenuEditScreen extends StatefulWidget {
  final Menu menu;
  MenuEditScreen({this.menu});

  @override
  _MenuEditScreenState createState() => _MenuEditScreenState();
}

class _MenuEditScreenState extends State<MenuEditScreen> {
  final picker = ImagePicker();
  File _image;

  // Edit
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _discValueController =
      TextEditingController(text: "0");
  final List<TextEditingController> _listStockController = [];
  String _discType = "fixed";
  bool _isDiscount = false;
  int _priceAfterDiscount = 0;
  bool _useInventory = false;
  int _categoryId;
  List<Inventory> _inventoryList = [];
  List<MenuInventory> _menuInventory = [];
  int _storeId = 0;

  @override
  void initState() {
    super.initState();
    if (widget.menu != null) {
      initMenu();
    }
  }

  void initMenu() {
    Menu menu = widget.menu;
    _nameController.text = menu.name;
    _priceController.text = menu.price.toString();
    _descController.text = menu.description;
    _codeController.text = menu.code;
    _discValueController.text = menu.discountValue.toString();
    _isDiscount = menu.isDiscount;
    _discType = menu.discountType;
    _useInventory = menu.useInventory;
    _priceAfterDiscount = calculateValueAfterDiscount();
    _menuInventory = menu.inventory;
    for (int i = 0; i < _menuInventory.length; i++) {
      _listStockController
          .add(TextEditingController(text: _menuInventory[i].total.toString()));
    }
  }

  Future getImage() async {
    final item = await picker.getImage(source: ImageSource.gallery);
    if (item != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: item.path,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: kPrimary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(
            title: 'Crop Image',
          ));
      setState(() {
        _image = croppedFile;
      });
    }
  }

  int calculateValueAfterDiscount() {
    if (_discType == "fixed") {
      return (double.parse(_priceController.text).round() -
          double.parse(_discValueController.text).round());
    } else {
      return (double.parse(_priceController.text) -
              (double.parse(_priceController.text) *
                  double.parse(_discValueController.text) /
                  100))
          .round();
    }
  }

  Future submit(MenuModel model) async {
    List<MenuInventory> newInventory = _menuInventory;
    for (int i = 0; i < _listStockController.length; i++) {
      newInventory[i].total = int.parse(_listStockController[i].text);
    }
    Menu menu = Menu(
        storeId: _storeId,
        id: widget.menu == null ? 0 : widget.menu.id,
        code: _codeController.text,
        description: _descController.text,
        discountType: _discType,
        discountValue: double.parse(_discValueController.text),
        isDiscount: _isDiscount,
        name: _nameController.text,
        price: double.parse(_priceController.text),
        categoryId: _categoryId,
        useInventory: _useInventory,
        inventory: newInventory);
    if (await model.saveMenu(menu, _image)) {
      Navigator.of(context).pushReplacementNamed("menu");
    }
  }

  @override
  Widget build(BuildContext context) {
    int storeId = Provider.of<UserStore>(context).id;
    return BaseScreen<MenuModel>(
      onModelReady: (menu) async {
        menu.currentMenu = widget.menu;
        await menu.getList(context);
        _inventoryList = menu.storeInventory;
        setState(() {
          _storeId = storeId;
        });
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: widget.menu == null ? Text("Add Menu") : Text("Edit Menu"),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () => submit(model),
                ))
          ],
        ),
        body: model.state == StateStatus.Unloaded
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Center(
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: _image == null
                                    ? widget.menu == null ||
                                            widget.menu.photo == ""
                                        ? Container(
                                            child: Icon(
                                            Icons.image_not_supported,
                                            size: 80,
                                            color: Colors.grey,
                                          ))
                                        : Image.network(widget.menu.photo)
                                    : Image.file(_image),
                              ),
                            ),
                            FlatButton(
                              color: Colors.red,
                              onPressed: () => getImage(),
                              child: Text(
                                "Select Image",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                      TextInput(label: "Name", controller: _nameController),
                      TextInput(label: "Code", controller: _codeController),
                      Text("Category",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 12)),
                      DropdownButton(
                        hint: Text("Select Category"),
                        isExpanded: true,
                        value: _categoryId,
                        onChanged: (val) => {
                          setState(() {
                            _categoryId = val;
                          })
                        },
                        items: List<DropdownMenuItem>.from(model.categories.map(
                            (item) => DropdownMenuItem(
                                value: item.id, child: Text(item.name)))),
                      ),
                      TextInput(
                          label: "Price",
                          keyboardType: TextInputType.number,
                          controller: _priceController,
                          onChanged: (val) => setState(() {
                                _priceAfterDiscount =
                                    calculateValueAfterDiscount();
                              })),
                      TextInput(
                          label: "Description",
                          controller: _descController,
                          maxLines: 3),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Discount Value",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                            Row(
                              children: [
                                Checkbox(
                                    value: _isDiscount,
                                    onChanged: (val) => setState(() {
                                          _isDiscount = val;
                                        })),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: TextInput(
                                        label: "",
                                        keyboardType: TextInputType.number,
                                        controller: _discValueController,
                                        enabled: _isDiscount,
                                        onChanged: (val) => setState(() {
                                              _priceAfterDiscount =
                                                  calculateValueAfterDiscount();
                                            })),
                                  ),
                                ),
                                Expanded(
                                  child: DropdownButton(
                                      value: _discType,
                                      items: [
                                        DropdownMenuItem(
                                            value: "fixed",
                                            child: Text("Fixed (Rp.)")),
                                        DropdownMenuItem(
                                            value: "percent",
                                            child: Text("Percentage (%)"))
                                      ],
                                      onChanged: _isDiscount
                                          ? (String val) {
                                              setState(() {
                                                _discValueController.text = "";
                                                _discType = val;
                                              });
                                            }
                                          : null),
                                )
                              ],
                            ),
                            _isDiscount
                                ? Text(
                                    "Price after discount Rp $_priceAfterDiscount")
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Radio(
                                          groupValue: _useInventory,
                                          value: false,
                                          onChanged: (val) => setState(() {
                                            _useInventory = val;
                                          }),
                                        ),
                                        Text("Use Stock")
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Radio(
                                          groupValue: _useInventory,
                                          value: true,
                                          onChanged: (val) => setState(() {
                                            _useInventory = val;
                                          }),
                                        ),
                                        Text("Use Inventory")
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            _useInventory ? inventoryListWidget() : Container()
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void addMenuInventory(Inventory inventory) {
    bool exist = _menuInventory
            .where((item) => item.inventoryId == inventory.id)
            .toList()
            .length >
        0;
    if (!exist) {
      setState(() {
        MenuInventory mInventory = MenuInventory(
            inventoryId: inventory.id,
            name: inventory.name,
            menuId: widget.menu.id,
            total: 0,
            unit: inventory.unit);
        _menuInventory.add(mInventory);
        _listStockController.add(TextEditingController());
      });
    }
    Navigator.pop(context);
  }

  void toggleModal() {
    showDialog(
        context: context,
        child: AlertDialog(
            title: Text("Select Item"),
            content: ListView.builder(
                shrinkWrap: true,
                itemCount: _inventoryList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => addMenuInventory(_inventoryList[index]),
                    title: Text(_inventoryList[index].name),
                  );
                })));
  }

  Widget inventoryListWidget() {
    return Container(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Inventory List"),
            ListView.builder(
                shrinkWrap: true,
                itemCount: _menuInventory.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Row(children: [
                      IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              _menuInventory = _menuInventory
                                  .where((item) =>
                                      item.inventoryId !=
                                      _menuInventory[index].inventoryId)
                                  .toList();
                            });
                          }),
                      Expanded(child: Text(_menuInventory[index].name)),
                      Container(
                        width: 60,
                        child: TextField(
                          controller: _listStockController[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.end,
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.all(2)),
                        ),
                      ),
                      Text(_menuInventory[index].unit)
                    ]),
                  );
                }),
            Container(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => toggleModal(),
                child: Text("+", style: TextStyle(fontSize: 18)),
              ),
            )
          ],
        ));
  }
}
