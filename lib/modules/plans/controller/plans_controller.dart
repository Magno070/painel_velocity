import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:painel_velocitynet/constantes/api_url.dart';

class PlansController {
  getPlans() async {
    Uri url = Uri.parse("${ApiContants.baseApi}/plans");
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      return response.body;
    }
  }

  void deletePlans(String itemId, String token) async {
    final url = Uri.parse("${ApiContants.baseApi}/plans");

    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode({"id": itemId}),
      );

      if (response.statusCode == 200) {
        getPlans();
      } else {
        if (kDebugMode) {
          print('Erro ao excluir o item: ${response.statusCode}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Erro na solicitação DELETE: $error');
      }
    }
  }
}
