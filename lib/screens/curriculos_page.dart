import 'package:flutter/material.dart';
import 'package:velocity_admin_painel/models/screen_menu.dart';

class CurriculosPage extends StatelessWidget {
  const CurriculosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenMenu(
      selectedItemId: 'CURRICULOS',
      newChild: Container(color: Colors.orange),
      pageTitleText: 'GERENCIAMENTO DE CURRÍCULOS',
    );
  }
}
