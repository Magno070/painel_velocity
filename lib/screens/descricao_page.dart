import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_admin_painel/models/screen_menu.dart';

class DescricaoPage extends StatelessWidget {
  const DescricaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenMenu(
        pageTitle: 'GERENCIAMENTO DE DESCRIÇÃO',
        newChild: Text(
          'DESCRICÃO',
          style: GoogleFonts.poppins(fontSize: 40, color: Colors.white),
          textAlign: TextAlign.end,
        ),
      ),
    );
  }
}
