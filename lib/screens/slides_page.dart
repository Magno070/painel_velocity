import 'package:flutter/material.dart';
import 'package:velocity_admin_painel/models/screen_menu.dart';

class SlidesPage extends StatelessWidget {
  const SlidesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenMenu(
        selectedItemId: 'SLIDES',
        pageTitleText: 'GERENCIAMENTO DE SLIDES',
        newChild: Container(color: Colors.yellow),
      ),
    );
  }
}
