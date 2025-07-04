import 'package:flutter/material.dart';
import 'package:painel_velocitynet/modules/config/config_repository/config_repository.dart';
import 'package:painel_velocitynet/modules/config/model/category_model.dart';

class ConfigProvider extends ChangeNotifier {
  List<CategoryModel> category = [];
  loadCategory() async {
    category = await ConfigRepository().categoryPlans();
    notifyListeners();
  }
}
