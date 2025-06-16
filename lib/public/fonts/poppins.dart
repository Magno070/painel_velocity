import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PoppinsNormal extends StatelessWidget {
  final double size;
  final String text;
  final Color color;

  const PoppinsNormal(
    this.text, {
    super.key,
    this.size = 16.0,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.poppins(color: color, fontSize: size));
  }
}

class PoppinsBold extends StatelessWidget {
  final double size;
  final String text;
  final Color color;

  const PoppinsBold(
    this.text, {
    super.key,
    this.size = 16.0,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
