import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_admin_painel/models/painel_navigator.dart';
import 'package:velocity_admin_painel/screens/beneficios_page.dart';
import 'package:velocity_admin_painel/screens/combos_page.dart';
import 'package:velocity_admin_painel/screens/curriculos_page.dart';
import 'package:velocity_admin_painel/screens/slides_page.dart';

class MenuItem {
  final String id;
  final String title;
  final IconData icon;
  final Widget page;

  const MenuItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.page,
  });
}

class ScreenMenu extends StatelessWidget {
  final Widget newChild;
  final String pageTitleText;
  final String selectedItemId;

  const ScreenMenu({
    super.key,
    required this.newChild,
    required this.pageTitleText,
    required this.selectedItemId,
  });

  static final List<MenuItem> _menuItems = [
    MenuItem(
      id: 'SLIDES',
      title: 'Slides',
      icon: Icons.library_books_outlined,
      page: const SlidesPage(),
    ),

    MenuItem(
      id: 'BENEFICIOS',
      title: 'Benefícios',
      icon: Icons.lightbulb_circle_outlined,
      page: const BeneficiosPage(),
    ),
    MenuItem(
      id: 'COMBOS',
      title: 'Combos',
      icon: Icons.local_offer_outlined,
      page: const CombosPage(),
    ),
    MenuItem(
      id: 'CURRICULOS',
      title: 'Currículos',
      icon: Icons.picture_as_pdf_outlined,
      page: const CurriculosPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const Color selectedColor = Color(0xFF424242);
    const Color unselectedColor = Color(0xFF181818);

    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Row(
        children: [
          Container(
            color: const Color(0xFF181818),
            width: 280,
            height: double.infinity,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                  width: 240,
                  child: Image.asset('assets/img/logo.png'),
                ),

                ListView.builder(
                  shrinkWrap:
                      true, // Essencial para ListView dentro de uma Column que não tem altura fixa ou não está em um Expanded
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _menuItems.length,
                  itemBuilder: (context, index) {
                    final item = _menuItems[index];
                    return PainelNavigator(
                      route: item.page,
                      iconData: item.icon,
                      textContent: item.title,
                      color:
                          item.id == selectedItemId
                              ? selectedColor
                              : unselectedColor,
                    );
                  },
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
                    child: Text(
                      pageTitleText,
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        color: Colors.white,
                      ),
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
