import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:painel_velocitynet/modules/config/component/combos/service/models/plan_model.dart';

class PlanService {
  static const String baseUrl = 'https://api.velocitynet.com.br/api/v1';
  static const Duration _timeout = Duration(seconds: 15);
  static const int _maxRetries = 2;

  Future<List<Plan>> loadPlanData() async {
    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        final response = await http
            .get(
              Uri.parse('$baseUrl/planos'),
              headers: buildHeaders(),
            )
            .timeout(_timeout);

        return _handleResponse(response, (body) {
          return List<Plan>.from(body.map((item) => Plan.fromJson(item)));
        });
      } catch (e) {
        if (attempt == _maxRetries) rethrow;
        await Future.delayed(_retryDelay(attempt));
      }
    }
    throw Exception('Falha após $_maxRetries tentativas');
  }

  Future<void> createPlan(Map<String, dynamic> planData) async {
    final correctedData = _fixDataStructure(planData);

    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        final response = await http
            .post(
              Uri.parse('$baseUrl/criarPlanos'),
              headers: buildHeaders(),
              body: jsonEncode(correctedData),
            )
            .timeout(_timeout);

        return _handleResponse(response, (_) => null);
      } catch (e) {
        if (attempt == _maxRetries) rethrow;
        await Future.delayed(_retryDelay(attempt));
      }
    }
  }

  Future<void> updatePlan(String id, Map<String, dynamic> planData) async {
    final correctedData = _fixDataStructure(planData);

    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        final response = await http
            .put(
              Uri.parse('$baseUrl/atualizarPlanos/$id'),
              headers: buildHeaders(),
              body: jsonEncode(correctedData),
            )
            .timeout(_timeout);

        return _handleResponse(response, (_) => null);
      } catch (e) {
        if (attempt == _maxRetries) rethrow;
        await Future.delayed(_retryDelay(attempt));
      }
    }
  }

  // Métodos auxiliares
  Map<String, String> buildHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Duration _retryDelay(int attempt) {
    return Duration(seconds: attempt); // Delay linear: 1s, 2s...
  }

  Map<String, dynamic> _fixDataStructure(Map<String, dynamic> data) {
    return {
      'nome': data['nome'],
      'velocidade': data['velocidade'],
      'valor': data['valor'],
      'beneficios': (data['beneficios'] as List?)
              ?.map((b) =>
                  {'nome': b['nome'], 'valor': b['valor'], 'image': b['image']})
              .toList() ??
          [],
    };
  }

  T _handleResponse<T>(http.Response response, T Function(dynamic) onSuccess) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return onSuccess(jsonDecode(response.body));
    } else {
      throw createException(response);
    }
  }

  Exception createException(http.Response response) {
    final status = response.statusCode;
    final message = 'HTTP $status: ${response.reasonPhrase}';
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    return HttpException(
      message,
      statusCode: status,
      responseBody: body,
    );
  }
}

class HttpException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic responseBody;

  HttpException(this.message, {this.statusCode, this.responseBody});

  @override
  String toString() {
    return 'HttpException: $message'
        '${statusCode != null ? ' (Status: $statusCode)' : ''}'
        '${responseBody != null ? '\nResponse: $responseBody' : ''}';
  }
}
