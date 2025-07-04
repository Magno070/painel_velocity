import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:painel_velocitynet/constantes/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:painel_velocitynet/modules/config/model/category_model.dart';

class ConfigRepository {
  List<CategoryModel> category = [];

  List<CategoryModel> parserCategory(String responseBody) {
    var list = json.decode(responseBody) as List<dynamic>;
    var categories = list.map((e) => CategoryModel.fromJson(e)).toList();
    return categories;
  }

  Future<List<CategoryModel>> categoryPlans() async {
    // String? token = await GetToken().getTokenFromLocalStorage();
    final response = await http.get(
      Uri.parse('${ApiContants.baseApi}/category-plan'),
      // headers: {
      //   'Content-Type': 'application/json',
      //   'Accept': 'application/json',
      //   'Authorization': 'Bearer $token',
      // },
    );

    if (response.statusCode == 200) {
      category = await compute(parserCategory, response.body);
      return category;
    } else {
      throw Exception(response.statusCode);
    }
  }
}
