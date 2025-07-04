import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListTileComponent extends StatefulWidget {
  final void Function()? changePage;
  final int selectedIndex;
  final int numberIndex;
  final String title;
  final IconData icon;

  const ListTileComponent(
      {super.key,
      required this.changePage,
      required this.selectedIndex,
      required this.title,
      required this.numberIndex,
      required this.icon});

  @override
  State<ListTileComponent> createState() => _ListTileComponentState();
}

class _ListTileComponentState extends State<ListTileComponent> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 15, bottom: 5, top: 5),
      leading: Icon(
        widget.icon,
        color: Colors.white,
      ),
      title: MediaQuery.of(context).size.width < 800
          ? null
          : Text(
              widget.title,
              style: GoogleFonts.getFont('Poppins',
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
      onTap: widget.changePage,
      tileColor: widget.selectedIndex == widget.numberIndex
          ? const Color(0x995F5FA7)
          : null,
    );
  }
}
