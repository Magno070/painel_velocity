import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:painel_velocitynet/constantes/api_url.dart';
import 'package:http/http.dart' as http;

class OfferController {
  Future getOffer() async {
    Uri url = Uri.parse('${ApiContants.baseApi}/offer');
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  Future patchOffer(
    String id,
    String novoTitulo,
    String novaDescricao,
    String novoValor,
    String token,
  ) async {
    Uri url = Uri.parse('${ApiContants.baseApi}/offer');
    Map<String, String> body = {
      'id': id,
      'title': novoTitulo,
      'description': novaDescricao,
      'value': novoValor,
    };

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    http.Response response =
        await http.patch(url, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Dados da oferta atualizados com sucesso!');
      }
      if (kDebugMode) {
        print(response.body);
      }
      getOffer();
    } else {
      if (kDebugMode) {
        print(
            'Erro ao atualizar os dados da oferta. Status code: ${response.statusCode}');
      }
    }
  }
}
