import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_admin_painel/models/screen_menu.dart';

class CombosPage extends StatelessWidget {
  const CombosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenMenu(
      newChild: Text(
        'COMBOS',
        style: GoogleFonts.poppins(fontSize: 40, color: Colors.white),
      ),
      pageTitle: 'GERENCIAMENTO DE COMBOS',
    );
  }
}
