import 'package:flutter/material.dart';
import 'package:pos_mobile/core/viewmodels/menu_model.dart';
import 'package:pos_mobile/ui/screens/base_screen.dart';

class MenuHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen<MenuModel>(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Stock History"),
        ),
        body: Container(),
      ),
    );
  }
}
