import 'package:flutter/material.dart';
import 'package:pos_mobile/ui/layout/main_layout.dart';

class StoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView(
            children: [
              ListTile(
                title: Text("Information"),
                onTap: () =>
                    Navigator.of(context).pushNamed("store_information"),
              ),
              Divider(),
              ListTile(
                title: Text("Gallery"),
              ),
              Divider()
            ],
          ),
        ),
        title: "Store");
  }
}
