import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_admin_painel/screens/login_page.dart';

class PainelNavigator extends StatelessWidget {
  final String textContent;
  final IconData iconData;
  final Color color;

  const PainelNavigator({
    super.key,
    required this.iconData,
    required this.textContent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final Icon icon = Icon(iconData, color: Colors.white, size: 40);
    final Text text = Text(
      textContent,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    );
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(color),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(36, 10, 0, 16),
        child: Row(children: [icon, SizedBox(width: 10), text]),
      ),
    );
  }
}

class ExitPainelNavigator extends StatelessWidget {
  final Color color;

  const ExitPainelNavigator({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    final Icon icon = Icon(
      Icons.exit_to_app_outlined,
      color: Colors.red,
      size: 40,
    );
    final Text text = Text(
      'Sair',
      style: GoogleFonts.poppins(
        color: Colors.red,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    );
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(color),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(36, 10, 0, 16),
        child: Row(children: [icon, SizedBox(width: 10), text]),
      ),
    );
  }
}
