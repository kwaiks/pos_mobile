import 'package:pos_mobile/core/utils/api_helper.dart';
import 'package:pos_mobile/core/utils/shared_preference.dart';
import 'package:pos_mobile/core/viewmodels/base_model.dart';
import 'package:pos_mobile/injector.dart';

class SplashModel extends BaseModel {
  final CustomSharedPreferences _customSharedPreferences =
      injector<CustomSharedPreferences>();
  final APIHelper _apiHelper = injector<APIHelper>();

  Future<bool> userExist() async {
    _apiHelper.initializeToken();
    return await _customSharedPreferences.loadUser();
  }
}
