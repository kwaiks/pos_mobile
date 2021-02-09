import 'package:flutter/material.dart';
import 'package:pos_mobile/core/enums/state_status.dart';
import 'package:pos_mobile/core/models/category.dart';
import 'package:pos_mobile/core/models/user.dart';
import 'package:pos_mobile/core/utils/debouncer.dart';
import 'package:pos_mobile/core/viewmodels/category_model.dart';
import 'package:pos_mobile/ui/layout/main_layout.dart';
import 'package:pos_mobile/ui/screens/base_screen.dart';
import 'package:pos_mobile/ui/widgets/text_input.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  CategoryModel _catModel;
  int storeId = 0;

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    storeId = Provider.of<UserStore>(context).id;
    return BaseScreen<CategoryModel>(
      onDestroy: (cat) => {_debouncer.destroy()},
      onModelReady: (cat) {
        cat.getCategories(storeId);
        _catModel = cat;
      },
      builder: (context, model, child) => MainLayout(
        suffix: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: GestureDetector(
              onTap: () => _openDialog(), child: Icon(Icons.add)),
        ),
        title: "Menu Category",
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    _debouncer.run(() => model.searchCategoryByName(query));
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
                        itemCount: model.categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return categoryListItem(
                              model.categories[index], context);
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

  Widget categoryListItem(Category cat, BuildContext context) {
    return Container(
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
                  Text(cat.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              )
            ]));
  }

  void _openDialog() {
    final TextEditingController _nameController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("New Category"),
            actions: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                  onPressed: () {
                    Category newCat =
                        Category(storeId: storeId, name: _nameController.text);
                    _catModel.addCategory(newCat);
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
                  ],
                ),
              );
            }),
          );
        });
  }
}
