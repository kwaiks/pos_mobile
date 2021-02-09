import 'package:flutter/material.dart';
import 'package:pos_mobile/core/enums/state_status.dart';
import 'package:pos_mobile/core/utils/debouncer.dart';
import 'package:pos_mobile/core/viewmodels/menu_model.dart';
import 'package:pos_mobile/ui/layout/main_layout.dart';
import 'package:pos_mobile/ui/screens/base_screen.dart';
import 'package:pos_mobile/ui/widgets/menu_item.dart';

class MenuScreen extends StatelessWidget {
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseScreen<MenuModel>(
      onDestroy: (menu) => {_debouncer.destroy()},
      onModelReady: (menu) => menu.getMenus(context),
      builder: (context, model, child) => MainLayout(
        suffix: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed("menu_edit"),
              child: Icon(Icons.add)),
        ),
        title: "Menu",
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    _debouncer.run(() => model.searchMenuByName(query));
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
                        itemCount: model.menuList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MenuItem(menu: model.menuList[index]);
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
}
