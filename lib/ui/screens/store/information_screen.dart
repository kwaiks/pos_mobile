import 'package:flutter/material.dart';
import 'package:pos_mobile/core/enums/state_status.dart';
import 'package:pos_mobile/core/models/user.dart';
import 'package:pos_mobile/core/viewmodels/store_model.dart';
import 'package:pos_mobile/ui/screens/base_screen.dart';
import 'package:provider/provider.dart';

class StoreInformationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int storeId = Provider.of<UserStore>(context).id;
    return BaseScreen<StoreModel>(
      onModelReady: (store) => store.getStore(storeId),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Store Information"),
          ),
          body: model.state == StateStatus.Preparing
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                            width: 100,
                            height: 100,
                            child:
                                model.store == null || model.store.picture == ""
                                    ? Container(
                                        child: Icon(
                                        Icons.image_not_supported,
                                        size: 80,
                                        color: Colors.grey,
                                      ))
                                    : Image.network(model.store.picture)),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Name", style: TextStyle(fontSize: 16.0)),
                              Text(model.store.name,
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
                              Text("Location",
                                  style: TextStyle(fontSize: 16.0)),
                              Text(model.store.location,
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
                              Text("Phone Number",
                                  style: TextStyle(fontSize: 16.0)),
                              Text(model.store.phone,
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
                              Text("Description",
                                  style: TextStyle(fontSize: 16.0)),
                              Text(model.store.description,
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
                              Text("Tax", style: TextStyle(fontSize: 16.0)),
                              Text(model.store.tax.toString() + "%",
                                  style: TextStyle(fontSize: 20.0))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
