import 'package:pos_mobile/core/enums/state_status.dart';
import 'package:pos_mobile/core/models/category.dart';
import 'package:pos_mobile/core/models/inventory.dart';
import 'package:pos_mobile/core/services/category_service.dart';
import 'package:pos_mobile/core/viewmodels/base_model.dart';
import 'package:pos_mobile/injector.dart';

class CategoryModel extends BaseModel {
  final CategoryService _categoryService = injector<CategoryService>();

  String errorMessage = "";
  Inventory inventory;
  List<Category> defaultList = [];
  List<Category> categories = [];

  Future getCategories(int storeId) async {
    setState(StateStatus.Preparing);
    try {
      categories = await _categoryService.getCategories(storeId);
      defaultList = categories;
    } catch (e) {
      errorMessage = e;
    }
    setState(StateStatus.Loaded);
  }

  Future addCategory(Category cat) async {
    setState(StateStatus.Preparing);
    try {
      Category addedInv = await _categoryService.addCategory(cat);
      categories.add(addedInv);
      defaultList.add(addedInv);
      setState(StateStatus.Loaded);
    } catch (e) {
      setState(StateStatus.Loaded);
      errorMessage = e;
    }
  }

  void searchCategoryByName(String name) {
    setState(StateStatus.Preparing);
    List<Category> newList = defaultList
        .where((cat) => cat.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
    categories = newList;
    setState(StateStatus.Loaded);
  }
}
