import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:painel_velocitynet/constantes/api_url.dart';

class ApiService {
  static Future<void> fazerRequisicaoAutenticada(String token) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.post(
        Uri.parse("${ApiContants.baseApi}/login"),
        headers: headers,
      );
      if (response.statusCode == 200) {
      } else {
        if (kDebugMode) {
          print("Erro na API: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao fazer a requisição: $e");
      }
    }
  }
}
