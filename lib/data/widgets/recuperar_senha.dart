import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_admin_painel/models/mytextformfield.dart';

class RecEmail extends StatelessWidget {
  final TextEditingController recEmailController;
  final VoidCallback enviarFunction;
  final VoidCallback sairFunction;

  const RecEmail({
    super.key,
    required this.recEmailController,
    required this.enviarFunction,
    required this.sairFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Recuperação de senha',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 40),
        SizedBox(
          width: 390,
          child: Text(
            'Insira o e-mail da sua conta para receber o codigo de verificação',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
          ),
        ),
        SizedBox(height: 20),
        MyTextFormField(
          controller: recEmailController,
          labelText: 'E-mail',
          icon: Icons.mail_outline_outlined,
        ),
        SizedBox(height: 40),
        SizedBox(
          width: 390,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: ElevatedButton(
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
                    if (recEmailController.text.isEmpty) {
                      return;
                    } else {
                      enviarFunction();
                    }
                  },
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        'Enviar',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Flexible(
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    backgroundColor: WidgetStatePropertyAll(
                      Color.fromARGB(255, 103, 11, 11),
                    ),
                  ),
                  onPressed: sairFunction,
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        'Sair',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RecCodigo extends StatelessWidget {
  final TextEditingController recCodeController;
  final VoidCallback confirmarFunction;
  final VoidCallback cancelarFunction;

  const RecCodigo({
    super.key,
    required this.recCodeController,
    required this.confirmarFunction,
    required this.cancelarFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Código enviado!',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 40),
        SizedBox(
          width: 390,
          child: Text(
            'Insira o código que foi enviado para seu e-mail',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20),
        MyTextFormField(
          controller: recCodeController,
          labelText: 'Código',
          icon: Icons.onetwothree_outlined,
        ),
        SizedBox(height: 40),
        SizedBox(
          width: 390,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: ElevatedButton(
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
                  onPressed: confirmarFunction,
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        'Confirmar',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Flexible(
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    backgroundColor: WidgetStatePropertyAll(
                      Color.fromARGB(255, 103, 11, 11),
                    ),
                  ),
                  onPressed: cancelarFunction,
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        'Cancelar',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
