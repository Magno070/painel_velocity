import 'package:flutter/material.dart';
import 'package:painel_velocitynet/modules/entity/menu_entity.dart';

import 'package:painel_velocitynet/pages/login.dart';
import 'package:painel_velocitynet/modules/login/auth_maneger.dart';

class Exit extends StatefulWidget {
  static const route = 'Sair';
  final MenuEntity menu;
  const Exit({super.key, required this.menu});

  @override
  State<Exit> createState() => _ExitState();
}

class _ExitState extends State<Exit> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff292929),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () async {
                final navigator = Navigator.of(context);
                // 1. Centraliza a lógica de logout usando o AuthManager
                await AuthManager.clearToken();

                // 2. Navega para a tela de login e remove todas as rotas anteriores
                navigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Login()),
                    (Route<dynamic> route) => false);
              },
              child: const Text(
                'Sair da Conta',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
