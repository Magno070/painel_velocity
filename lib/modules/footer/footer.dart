import 'package:flutter/material.dart';
import 'package:painel_velocitynet/modules/entity/menu_entity.dart';

class Footer extends StatefulWidget {
  static const route = 'Rodapé';
  final MenuEntity menu;
  const Footer({super.key, required this.menu});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff292929),
    );
  }
}
