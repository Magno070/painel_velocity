import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:painel_velocitynet/constantes/api_url.dart';
import 'package:http/http.dart' as http;

class TvController {
  Future getTv() async {
    Uri url = Uri.parse('${ApiContants.baseApi}/tv');
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  Future patchTv(String id, String novoTitulo, String novaDescricao,
      String novoValor, String token) async {
    Uri url = Uri.parse('${ApiContants.baseApi}/tv');

    Map<String, String> body = {
      'id': id,
      'title': novoTitulo,
      'description': novaDescricao,
      'value': novoValor
    };

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    http.Response response =
        await http.patch(url, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      getTv();
    } else {
      if (kDebugMode) {
        print(
            'Erro ao atualizar os dados da tv, Status code: ${response.statusCode}');
      }
    }
  }
}
