import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_admin_painel/screens/slide_page.dart';

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
                      borderSide: BorderSide(width: 3.0, color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
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
                        Icon(Icons.person, color: Colors.grey[400], size: 30),
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
                      borderSide: BorderSide(width: 3.0, color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromARGB(255, 11, 31, 103),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SlidePage()),
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
