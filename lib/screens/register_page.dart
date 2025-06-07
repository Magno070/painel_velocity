import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
          height: 800,
          width: 600,
          padding: EdgeInsets.fromLTRB(30, 40, 30, 40),
          child: Column(
            children: [
              Image.asset('assets/img/logo.png', width: 360, fit: BoxFit.cover),
              SizedBox(height: 40),
              Text(
                'Bem-vindo ao painel, insira as informações necessárias para se registrar!',
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
                        Icon(
                          Icons.email_outlined,
                          color: Colors.grey[400],
                          size: 30,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'E-mail',
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
              SizedBox(height: 20),
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
                child: TextFormField(
                  decoration: InputDecoration(
                    label: Row(
                      children: [
                        Icon(Icons.password, color: Colors.grey[400], size: 30),
                        SizedBox(width: 8),
                        Text(
                          'Confirmar senha',
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
                  Navigator.pop(context);
                },
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: Center(
                    child: Text(
                      'Register',
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
