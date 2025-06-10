import 'package:flutter/material.dart';
import 'package:velocity_admin_painel/models/screen_menu.dart';

class BeneficiosPage extends StatelessWidget {
  const BeneficiosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenMenu(
        selectedItemId: 'BENEFICIOS',
        pageTitleText: 'GERENCIAMENTO DE BENEFÍCIOS',
        newChild: Container(color: Colors.red),
      ),
    );
  }
}
