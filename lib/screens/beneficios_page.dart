import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_admin_painel/models/screen_menu.dart';

class BeneficiosPage extends StatelessWidget {
  const BeneficiosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenMenu(
        pageTitle: 'GERENCIAMENTO DE BENEFÍCIOS',
        newChild: Text(
          'BENEFÍCIOS',
          style: GoogleFonts.poppins(fontSize: 40, color: Colors.white),
        ),
      ),
    );
  }
}
