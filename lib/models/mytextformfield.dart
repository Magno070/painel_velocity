import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_admin_painel/public/fonts/poppins.dart';

class MyTextFormField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitt;

  const MyTextFormField({
    super.key,
    required this.labelText,
    required this.icon,
    this.obscureText = false,
    this.controller,
    this.onSubmitt,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 390,
      child: TextFormField(
        onFieldSubmitted: onSubmitt,
        controller: controller,
        obscureText: obscureText,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 21),
        decoration: InputDecoration(
          label: Row(
            children: [
              Icon(icon, color: Colors.grey[400], size: 30),
              SizedBox(width: 8),
              Poppins(labelText, color: Colors.grey[400]!, size: 20),
            ],
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 3.0, color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 1.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
