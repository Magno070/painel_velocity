import 'package:flutter/material.dart';
import 'package:velocity_admin_painel/models/painel_navigator.dart';

class SlidePage extends StatelessWidget {
  final Widget expandedChild;

  const SlidePage({super.key, required this.expandedChild});

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = const Color(0xFF424242);
    final Color unselectedColor = Color(0xFF181818);
    return Scaffold(
      body: Row(
        children: [
          Container(
            color: Color(0xFF181818),
            width: 350,
            height: double.infinity,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, 16, 20, 40),
                  width: 300,
                  child: Image.asset('assets/img/logo.png'),
                ),
                PainelNavigator(
                  iconData: Icons.library_books_outlined,
                  textContent: 'Slides',
                  color: selectedColor,
                ),
                PainelNavigator(
                  iconData: Icons.description,
                  textContent: 'Descrição',
                  color: unselectedColor,
                ),
                PainelNavigator(
                  iconData: Icons.lightbulb_circle_outlined,
                  textContent: 'Benefícios',
                  color: unselectedColor,
                ),
                PainelNavigator(
                  iconData: Icons.local_offer_outlined,
                  textContent: 'Combos',
                  color: unselectedColor,
                ),
                PainelNavigator(
                  iconData: Icons.picture_as_pdf_outlined,
                  textContent: 'Currículos',
                  color: unselectedColor,
                ),
                ExitPainelNavigator(color: unselectedColor),
              ],
            ),
          ),
          Expanded(child: expandedChild),
        ],
      ),
    );
  }
}
