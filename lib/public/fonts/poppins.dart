import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Poppins extends StatelessWidget {
  final double size;
  final String text;
  final Color color;
  final bool bold;

  const Poppins(
    this.text, {
    super.key,
    this.size = 16.0,
    this.color = Colors.white,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: color,
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
