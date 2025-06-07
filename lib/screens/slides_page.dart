import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_admin_painel/models/screen_menu.dart';

class SlidesPage extends StatelessWidget {
  const SlidesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenMenu(
        pageTitle: 'GERENCIAMENTO DE SLIDES',
        newChild: Text(
          'SLIDES',
          style: GoogleFonts.poppins(fontSize: 40, color: Colors.white),
        ),
      ),
    );
  }
}
