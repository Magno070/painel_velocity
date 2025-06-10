import 'package:flutter/material.dart';
import 'package:velocity_admin_painel/models/screen_menu.dart';

class DescricaoPage extends StatelessWidget {
  const DescricaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenMenu(
        selectedItemId: 'DESCRICAO',
        pageTitleText: 'GERENCIAMENTO DE DESCRIÇÃO',
        newChild: Container(color: Colors.green),
      ),
    );
  }
}
