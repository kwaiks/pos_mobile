import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_mobile/core/services/category_service.dart';
import 'package:pos_mobile/core/services/inventory_service.dart';
import 'package:pos_mobile/core/services/menu_service.dart';
import 'package:pos_mobile/core/services/providers.dart';
import 'package:pos_mobile/core/services/store_service.dart';
import 'package:pos_mobile/core/utils/api_helper.dart';
import 'package:pos_mobile/core/utils/shared_preference.dart';
import 'package:pos_mobile/core/viewmodels/auth_model.dart';
import 'package:pos_mobile/core/viewmodels/category_model.dart';
import 'package:pos_mobile/core/viewmodels/inventory_model.dart';
import 'package:pos_mobile/core/viewmodels/menu_model.dart';
import 'package:pos_mobile/core/viewmodels/splash_model.dart';
import 'package:pos_mobile/core/viewmodels/store_model.dart';
import 'package:pos_mobile/core/viewmodels/transaction_model.dart';

import 'core/services/auth_service.dart';

GetIt injector = GetIt.instance;

void setupInjector({bool test = false, Dio dioMock}) {
  if (test) {
    injector.registerLazySingleton(() => dioMock);
  } else {
    injector.registerLazySingleton(() => Dio());
  }
  injector.registerLazySingleton<APIHelper>(
    () => APIHelper(dio: injector<Dio>()),
  );
  injector.registerLazySingleton(() => CustomSharedPreferences());
  injector.registerLazySingleton(() => AuthService());
  injector.registerLazySingleton(() => MenuService());
  injector.registerLazySingleton(() => Providers());
  injector.registerLazySingleton(() => InventoryService());
  injector.registerLazySingleton(() => CategoryService());
  injector.registerLazySingleton(() => StoreService());

  injector.registerFactory(() => AuthModel());
  injector.registerFactory(() => MenuModel());
  injector.registerFactory(() => InventoryModel());
  injector.registerFactory(() => CategoryModel());
  injector.registerFactory(() => StoreModel());
  injector.registerFactory(() => TransactionModel());
  injector.registerFactory(() => SplashModel());
}
