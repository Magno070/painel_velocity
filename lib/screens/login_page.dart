import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_admin_painel/screens/register_page.dart';
import 'package:velocity_admin_painel/screens/slides_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Container(
          decoration: BoxDecoration(color: Colors.transparent),
          height: 600,
          width: 600,
          padding: EdgeInsets.fromLTRB(30, 40, 30, 40),
          child: Column(
            children: [
              Image.asset('assets/img/logo.png', width: 360, fit: BoxFit.cover),
              SizedBox(height: 40),
              Text(
                'Bem-vindo ao painel, faça seu Login!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 390,
                child: TextFormField(
                  decoration: InputDecoration(
                    label: Row(
                      children: [
                        Icon(Icons.person, color: Colors.grey[400], size: 30),
                        SizedBox(width: 8),

                        Text(
                          'Usuário',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[400],
                            fontSize: 20,
                          ),
                        ),
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
              ),
              SizedBox(height: 50),
              SizedBox(
                width: 390,
                child: TextFormField(
                  decoration: InputDecoration(
                    label: Row(
                      children: [
                        Icon(Icons.password, color: Colors.grey[400], size: 30),
                        SizedBox(width: 8),
                        Text(
                          'Senha',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[400],
                            fontSize: 20,
                          ),
                        ),
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
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 390,
                child: Row(
                  children: [
                    Text(
                      'Você é novo(a)?',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[400],
                        fontSize: 20,
                      ),
                    ),
                    TextButton(
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Registre-se agora!',
                        style: GoogleFonts.poppins(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromARGB(255, 11, 31, 103),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SlidesPage()),
                  );
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
          ),
        ),
      ),
    );
  }
}
