import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:painel_velocitynet/modules/config/component/combos/foryou.dart';

//~

class ForBusiness extends StatefulWidget {
  const ForBusiness({super.key});

  @override
  State<ForBusiness> createState() => _ForBusinessState();
}

List<Widget> childs = const [ForYou(), Placeholder()];

class _ForBusinessState extends State<ForBusiness> {
  List<String> screens = ['Para você', 'Para empresas'];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: screens.length,
          itemBuilder: (context, index) => ListTile(
                tileColor: Colors.grey[900],
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => childs[index],
                      ));
                },
                title: Text(
                  screens[index],
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                selectedTileColor: Colors.white,
              )),
    );
  }
}
