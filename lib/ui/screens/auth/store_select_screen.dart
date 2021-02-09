import 'package:flutter/material.dart';
import 'package:pos_mobile/core/models/user.dart';
import 'package:pos_mobile/core/services/providers.dart';
import 'package:pos_mobile/core/utils/colors.dart';
import 'package:pos_mobile/core/utils/shared_preference.dart';
import 'package:pos_mobile/injector.dart';

class StoreSelectScreen extends StatefulWidget {
  final List<UserStore> storeList;
  StoreSelectScreen(this.storeList);

  @override
  _StoreSelectScreenState createState() => _StoreSelectScreenState();
}

class _StoreSelectScreenState extends State<StoreSelectScreen> {
  final Providers _providers = injector<Providers>();
  final CustomSharedPreferences _customSharedPreferences =
      CustomSharedPreferences();
  UserStore currentStore;

  void selectStore(BuildContext context) {
    if (currentStore == null) {
      return;
    }
    _providers.setUserStore(currentStore);
    _customSharedPreferences.setActiveStore(currentStore);
    Navigator.of(context).pushReplacementNamed("home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Column(
                children: [
                  Text("Select Store",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0)),
                  currentStore != null
                      ? Text(currentStore.storeName)
                      : Container()
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: ListView.builder(
                    padding: const EdgeInsets.all(20.0),
                    shrinkWrap: true,
                    itemCount: widget.storeList.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return storeItem(widget.storeList[index]);
                    }),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
              width: double.infinity,
              child: FlatButton(
                color: kPrimary,
                onPressed: () => selectStore(context),
                child: Text("Select", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget storeItem(UserStore store) {
    return InkWell(
      onTap: () => setState(() {
        currentStore = store;
      }),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        decoration: BoxDecoration(
            border: Border.all(
                color: currentStore != null && currentStore.id == store.id
                    ? kPrimary
                    : Colors.black)),
        child: Text(
          store.storeName,
          style: TextStyle(
              color: currentStore != null && currentStore.id == store.id
                  ? kPrimary
                  : Colors.black),
        ),
      ),
    );
  }
}
