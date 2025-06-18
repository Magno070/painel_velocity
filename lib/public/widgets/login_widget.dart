import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_admin_painel/public/fonts/poppins.dart';
import 'package:velocity_admin_painel/public/secret/admins_data.dart';
import 'package:velocity_admin_painel/models/mytextformfield.dart';
import 'package:velocity_admin_painel/screens/slides_page.dart';

class LoginWidget extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback setFunction;

  const LoginWidget({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.setFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/img/logo.png', width: 360, fit: BoxFit.cover),
        SizedBox(height: 30),
        Poppins(
          'Bem-vindo ao painel, faça seu Login!',
          color: Colors.white,
          size: 20,
          bold: true,
        ),

        SizedBox(height: 30),
        MyTextFormField(
          labelText: 'Usuário',
          icon: Icons.person_outline,
          controller: usernameController,
        ),
        SizedBox(height: 40),
        MyTextFormField(
          onSubmitt: (value) => authLogin(context),
          labelText: 'Senha',
          obscureText: true,
          icon: Icons.password_outlined,
          controller: passwordController,
        ),
        SizedBox(height: 20),
        SizedBox(
          width: 250,
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateColor.resolveWith((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return Colors.white;
                }
                return Colors.transparent;
              }),
              foregroundColor: WidgetStateColor.resolveWith((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return Colors.black;
                }
                return Colors.yellow;
              }),
            ),
            onPressed: setFunction,
            child: Text(
              'Esqueci minha senha',
              style: GoogleFonts.poppins(fontSize: 20),
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            backgroundColor: WidgetStatePropertyAll(
              Color.fromARGB(255, 11, 31, 103),
            ),
          ),
          onPressed: () {
            authLogin(context);
          },
          child: SizedBox(
            width: 200,
            height: 50,
            child: Center(
              child: Text(
                'Login',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  authLogin(context) {
    var isLogged = false;
    for (var admin in adminsData) {
      if (admin['login'] == usernameController.text &&
          admin['senha'] == passwordController.text) {
        isLogged = true;
      }
    }
    if (isLogged) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SlidesPage()),
      );
    }
  }
}
