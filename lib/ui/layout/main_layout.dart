import "package:flutter/material.dart";
import 'package:pos_mobile/core/models/user.dart';
import 'package:pos_mobile/core/viewmodels/auth_model.dart';
import 'package:pos_mobile/ui/screens/base_screen.dart';
import 'package:provider/provider.dart';

class MainLayout extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget suffix;
  final Widget fab;
  MainLayout(
      {@required this.body, @required this.title, this.suffix, this.fab});

  @override
  Widget build(BuildContext context) {
    return BaseScreen<AuthModel>(
      builder: (context, model, child) {
        UserStore store = Provider.of<UserStore>(context);
        return SafeArea(
          child: Scaffold(
            floatingActionButton: fab,
            appBar: AppBar(
              title: Text(title),
              actions: [suffix != null ? suffix : Container()],
            ),
            drawer: Drawer(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          title: Text(
                            store != null ? store.storeName : "",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Divider(),
                        drawerItem(
                            icon: Icon(Icons.home),
                            context: context,
                            route: "home",
                            title: "Dashboard"),
                        Divider(),
                        drawerItem(
                            icon: Icon(Icons.fastfood),
                            context: context,
                            route: "menu",
                            title: "Menu"),
                        Divider(),
                        drawerItem(
                            icon: Icon(Icons.shopping_basket),
                            context: context,
                            route: "transaction",
                            title: "Transaction"),
                        Divider(),
                        drawerItem(
                            icon: Icon(Icons.food_bank),
                            context: context,
                            route: "inventory",
                            title: "Inventory"),
                        Divider(),
                        drawerItem(
                            icon: Icon(Icons.local_offer),
                            context: context,
                            route: "category",
                            title: "Category"),
                        Divider(),
                        drawerItem(
                            icon: Icon(Icons.store),
                            context: context,
                            route: "store",
                            title: "Store"),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                    onTap: () async {
                      if (await model.logout()) {
                        Navigator.of(context).pushReplacementNamed("login");
                      }
                    },
                  ),
                ],
              ),
            ),
            body: SafeArea(child: body),
          ),
        );
      },
    );
  }

  Widget drawerItem(
      {@required BuildContext context,
      @required Icon icon,
      @required String route,
      @required String title}) {
    return ListTile(
      dense: true,
      leading: icon,
      title: Text(title),
      onTap: () => Navigator.of(context).pushNamed(route),
    );
  }
}
