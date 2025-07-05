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
  late List<String> _tabTitles;

  @override
  void initState() {
    super.initState();
    _tabTitles = ['Para você', 'Para empresas'];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _tabTitles.length,
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

  void _showEditTabNameDialog(int index) {
    final controller = TextEditingController(text: _tabTitles[index]);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.grey[850],
        title: Text(
          'Editar nome da aba',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: GoogleFonts.poppins(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Novo nome',
            hintStyle: GoogleFonts.poppins(color: Colors.white54),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.yellow[400]!),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'CANCELAR',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, color: Colors.white70),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[500],
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _tabTitles[index] = controller.text.trim();
                });
              }
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              'SALVAR',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _tabs() {
    TextStyle poppinsStyle = GoogleFonts.poppins(
      fontSize: 15,
    );
    return _tabTitles.asMap().entries.map((entry) {
      final index = entry.key;
      final title = entry.value;
      return SizedBox(
        width: 200,
        child: Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: poppinsStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _showEditTabNameDialog(index),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.edit, size: 16, color: Colors.yellow[500]),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
