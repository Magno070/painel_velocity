import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:painel_velocitynet/modules/config/component/combos/forbusiness.dart';
import 'package:painel_velocitynet/modules/config/component/combos/foryou.dart';

class Combos extends StatefulWidget {
  const Combos({super.key});

  @override
  State<Combos> createState() => _CombosState();
}

class _CombosState extends State<Combos> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            SizedBox(
              height: 36,
              child: TabBar(
                tabs: _tabs(),
                tabAlignment: TabAlignment.center,
                dividerHeight: 0,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicator: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const Expanded(
                child: Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: TabBarView(children: [ForYou(), ForBusiness()]),
            ))
          ],
        ));
  }

  List<Widget> _tabs() {
    TextStyle poppinsStyle = GoogleFonts.poppins(
      fontSize: 15,
    );
    return [
      SizedBox(
        width: 160,
        child: Tab(
          child: Text(
            'Para você',
            style: poppinsStyle,
          ),
        ),
      ),
      SizedBox(
        width: 160,
        child: Tab(
          child: Text(
            'Para empresas',
            style: poppinsStyle,
          ),
        ),
      ),
    ];
  }
}
