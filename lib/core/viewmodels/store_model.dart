import 'dart:io';

import 'package:pos_mobile/core/enums/state_status.dart';
import 'package:pos_mobile/core/models/store.dart';
import 'package:pos_mobile/core/services/store_service.dart';
import 'package:pos_mobile/core/viewmodels/base_model.dart';
import 'package:pos_mobile/injector.dart';

class StoreModel extends BaseModel {
  final StoreService _storeService = injector<StoreService>();

  Store store;
  String errorMessage = "";

  Future getStore(int storeId) async {
    setState(StateStatus.Preparing);
    try {
      store = await _storeService.getStore(storeId);
      setState(StateStatus.Loaded);
    } catch (e) {
      setState(StateStatus.Loaded);
      errorMessage = e;
    }
  }

  Future editStore(Store store, File image) async {
    setState(StateStatus.Preparing);
    try {
      await _storeService.editStore(store, image);
      setState(StateStatus.Loaded);
    } catch (e) {
      setState(StateStatus.Loaded);
      errorMessage = e;
    }
  }
}
