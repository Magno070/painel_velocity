import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_admin_painel/models/screen_menu.dart';

class CurriculosPage extends StatelessWidget {
  const CurriculosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenMenu(
      newChild: Text(
        'CURRÍCULOS',
        style: GoogleFonts.poppins(fontSize: 40, color: Colors.white),
      ),
      pageTitle: 'GERENCIAMENTO DE CURRÍCULOS',
    );
  }
}
