import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:painel_velocitynet/modules/config/component/category.dart';
import 'package:painel_velocitynet/modules/config/component/combos.dart';
import 'package:painel_velocitynet/modules/entity/menu_entity.dart';

class PlansConfig extends StatefulWidget {
  static const route = 'Configurações';
  final MenuEntity menu;

  const PlansConfig({super.key, required this.menu});

  @override
  State<PlansConfig> createState() => _PlansConfigState();
}

class _PlansConfigState extends State<PlansConfig>
    with SingleTickerProviderStateMixin {
  late TabController _tabControllerr;

  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabControllerr = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TabBar(
                    overlayColor:
                        const WidgetStatePropertyAll(Colors.transparent),
                    controller: _tabControllerr,
                    dividerColor: Colors.black,
                    indicatorColor: Colors.transparent,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(
                      fontSize: 16,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 16,
                    ),
                    indicator: const BoxDecoration(
                      color: Color(
                        0xff181919,
                      ),
                    ),
                    tabs: _tabs(),
                  ),
                ),
                const Expanded(child: SizedBox.shrink())
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color(
                        0xff181919,
                      ),
                      border: Border(
                        bottom: BorderSide(color: Color(0xff2F2F2F), width: 1),
                        left: BorderSide(color: Color(0xff2F2F2F), width: 1),
                        right: BorderSide(color: Color(0xff2F2F2F), width: 1),
                      )),
                  child: TabBarView(
                    controller: _tabControllerr,
                    children: const <Widget>[
                      Combos(),
                      CategoryComponent(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _tabs() {
    TextStyle poppinsStyle = GoogleFonts.poppins(
        color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold);
    return [
      Tab(
        child: Container(
          padding: const EdgeInsets.only(
            left: 100,
            right: 100,
          ),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xff2F2F2F), width: 1),
              left: BorderSide(color: Color(0xff2F2F2F), width: 1),
              right: BorderSide(color: Color(0xff2F2F2F), width: 1),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
          child: Text(
            'Combos',
            style: poppinsStyle,
          ),
        ),
      ),
      Tab(
        child: Container(
          padding: const EdgeInsets.only(
            left: 100,
            right: 100,
          ),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xff2F2F2F), width: 1),
              left: BorderSide(color: Color(0xff2F2F2F), width: 1),
              right: BorderSide(color: Color(0xff2F2F2F), width: 1),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
          child: Text('Categorias', style: poppinsStyle),
        ),
      ),
    ];
  }
}
