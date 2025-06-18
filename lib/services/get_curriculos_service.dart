import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velocity_admin_painel/services/models/candidato.dart';

class ApiService {
  final String _baseUrl = 'https://api.velocitynet.com.br/api/v1';

  Future<List<Usuario>> getCandidates() async {
    final Uri url = Uri.parse('$_baseUrl/candidate/get');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decodifica o corpo da resposta JSON.
        List<dynamic> body = jsonDecode(response.body);

        List<Usuario> usuarios =
            body
                .map(
                  (dynamic item) =>
                      Usuario.fromJson(item as Map<String, dynamic>),
                )
                //TODO: Verificar o filtro de nulos após adicionar rota de delete
                .whereType<Usuario>() // Filtra os nulos retornados por fromJson
                .toList();
        return usuarios;
      } else {
        throw Exception(
          'Falha ao carregar candidatos (Status: ${response.statusCode}), Resposta: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao buscar candidatos: $e');
    }
  }
}
