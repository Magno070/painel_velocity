import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_admin_painel/models/painel_navigator.dart';
import 'package:velocity_admin_painel/screens/beneficios_page.dart';
import 'package:velocity_admin_painel/screens/combos_page.dart';
import 'package:velocity_admin_painel/screens/curriculos_page.dart';
import 'package:velocity_admin_painel/screens/descricao_page.dart';
import 'package:velocity_admin_painel/screens/slides_page.dart';

class ScreenMenu extends StatelessWidget {
  final Widget newChild;
  final String pageTitle;

  const ScreenMenu({
    super.key,
    required this.newChild,
    required this.pageTitle,
  });

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = const Color(0xFF424242);
    final Color unselectedColor = Color(0xFF181818);
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Row(
        children: [
          Container(
            color: Color(0xFF181818),
            width: 280,
            height: double.infinity,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, 16, 20, 40),
                  width: 240,
                  child: Image.asset('assets/img/logo.png'),
                ),
                PainelNavigator(
                  route: SlidesPage(),
                  iconData: Icons.library_books_outlined,
                  textContent: 'Slides',
                  color:
                      pageTitle.toUpperCase().contains('SLIDES')
                          ? selectedColor
                          : unselectedColor,
                ),
                PainelNavigator(
                  route: DescricaoPage(),
                  iconData: Icons.description,
                  textContent: 'Descrição',
                  color:
                      pageTitle.toUpperCase().contains('DESCRIÇÃO')
                          ? selectedColor
                          : unselectedColor,
                ),
                PainelNavigator(
                  route: BeneficiosPage(),
                  iconData: Icons.lightbulb_circle_outlined,
                  textContent: 'Benefícios',
                  color:
                      pageTitle.toUpperCase().contains('BENEFÍCIOS')
                          ? selectedColor
                          : unselectedColor,
                ),
                PainelNavigator(
                  route: CombosPage(),
                  iconData: Icons.local_offer_outlined,
                  textContent: 'Combos',
                  color:
                      pageTitle.toUpperCase().contains('COMBOS')
                          ? selectedColor
                          : unselectedColor,
                ),
                PainelNavigator(
                  route: CurriculosPage(),
                  iconData: Icons.picture_as_pdf_outlined,
                  textContent: 'Currículos',
                  color:
                      pageTitle.toUpperCase().contains('CURRÍCULOS')
                          ? selectedColor
                          : unselectedColor,
                ),
                ExitPainelNavigator(color: unselectedColor),
              ],
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          pageTitle,
                          style: GoogleFonts.poppins(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: newChild,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
