import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:painel_velocitynet/modules/curriculos/service/model/curriculo_model.dart';

class CurriculosApiService {
  final String _baseUrl = 'https://api.velocitynet.com.br/api/v1';

  // ~~ ---------------------------------------------------------------------------------------get

  Future<List<Usuario>> getCandidates() async {
    final Uri url = Uri.parse('$_baseUrl/candidate/get');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decodifica o corpo da resposta JSON.
        List<dynamic> body = jsonDecode(response.body);

        List<Usuario> usuarios = body
            .map(
              (dynamic item) => Usuario.fromJson(item as Map<String, dynamic>),
            )
            .whereType<Usuario>()
            .toList();
        return usuarios;
      } else {
        throw Exception(
          'Falha ao carregar candidatos da URL: $url (Status: ${response.statusCode}), Resposta: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao buscar candidatos da URL: $url. Detalhes: $e');
    }
  }
  // ~~ ---------------------------------------------------------------------------------------delete

  Future<String> deleteCandidate(String id) async {
    final Uri url = Uri.parse('$_baseUrl/candidate/delete');

    try {
      final res = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"id": id}),
      );

      if (res.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(res.body);
        return responseBody['msg'] as String;
      } else {
        throw Exception(
          'Falha ao deletar candidato da URL: $url (Status: ${res.statusCode}), Resposta: ${res.body}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao deletar candidato da URL: $url. Detalhes: $e');
    }
  }
}
