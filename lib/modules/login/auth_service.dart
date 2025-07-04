import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:painel_velocitynet/constantes/api_url.dart';
import 'package:painel_velocitynet/modules/login/api_service.dart';
import 'package:web/web.dart' as web;
import 'package:painel_velocitynet/modules/login/auth_maneger.dart';
import 'package:painel_velocitynet/modules/panel/panel.dart';

class AuthService extends ApiService {
  final TextEditingController controlerEmail;
  final TextEditingController controllerPassword;
  final BuildContext context;

  AuthService({
    required this.controlerEmail,
    required this.controllerPassword,
    required this.context,
  });

  Future<void> autentication() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    Map<String, String> body = {
      'email': controlerEmail.text,
      'password': controllerPassword.text,
    };

    http.Response response = await http.post(
        Uri.parse("${ApiContants.baseApi}/auth/login"),
        headers: headers,
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String token = responseData['token'];
      await AuthManager.setToken(token);
      web.window.localStorage.setItem('authToken', token);

      navigator.pushReplacement(MaterialPageRoute(
        builder: (context) => const Panel(),
      ));
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const MyTabbedPanel(),
      //   ),
      // );
      controlerEmail.clear();
      controllerPassword.clear();

      ApiService.fazerRequisicaoAutenticada(token);
    } else if (response.statusCode == 404) {
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: const Text('Usuário não cadastrado'),
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          onPressed: () {},
        ),
      );
      scaffoldMessenger.showSnackBar(snackBar);
    } else if (response.statusCode == 422) {
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: const Text('Usuário não cadastrado'),
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          onPressed: () {},
        ),
      );
      scaffoldMessenger.showSnackBar(snackBar);
    } else {
      if (kDebugMode) {
        print('Erro na API: ${response.statusCode}');
      }
    }
  }
}
