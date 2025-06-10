import 'package:flutter/material.dart';
import 'package:velocity_admin_painel/models/screen_menu.dart';

class CombosPage extends StatelessWidget {
  const CombosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenMenu(
      selectedItemId: 'COMBOS',
      newChild: Container(color: Colors.blueAccent),
      pageTitleText: 'GERENCIAMENTO DE COMBOS',
    );
  }
}
