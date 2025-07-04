import 'package:flutter/material.dart';
import 'package:painel_velocitynet/modules/entity/menu_entity.dart';

class Questions extends StatefulWidget {
  static const route = 'Perguntas';
  final MenuEntity menu;
  const Questions({super.key, required this.menu});

  @override
  State<Questions> createState() => _PerguntasState();
}

class _PerguntasState extends State<Questions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff292929),
    );
  }
}
