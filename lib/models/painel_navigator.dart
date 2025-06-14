import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_admin_painel/screens/login_page.dart';

class PainelNavigator extends StatelessWidget {
  final String textContent;
  final IconData iconData;
  final Color color;
  final Widget route;

  const PainelNavigator({
    super.key,
    required this.iconData,
    required this.textContent,
    required this.color,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final Icon icon = Icon(iconData, color: Colors.white, size: 40);
    final Text text = Text(
      textContent,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => route),
        );
      },
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(color),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 10, 0, 16),
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
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              backgroundColor: Colors.grey[850],
              title: Container(
                height: 200,
                width: 400,
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 390,
                      child: Text(
                        'Retornar a página inicial?',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 390,
                      child: Text(
                        'Você será redirecionado a pagina de login.',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 22,
                        ),
                      ),
                    ),
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
                                Navigator.of(dialogContext).pop();
                              },
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
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              },
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
                ),
              ),
            );
          },
        );
      },
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(color),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 10, 0, 16),
        child: Row(children: [icon, SizedBox(width: 10), text]),
      ),
    );
  }
}
